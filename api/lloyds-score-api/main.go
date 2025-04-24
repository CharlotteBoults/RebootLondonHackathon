package main

import (
	"context"
	"encoding/json"
	"io"
	"log"
	"net/http"
	"net/url"
	"strings"
	"time"

	// "gorm.io/driver/postgres"
	"gorm.io/gorm"

	"github.com/gin-contrib/cors"
	"github.com/gin-contrib/sessions"
	"github.com/gin-contrib/sessions/cookie"
	"github.com/gin-gonic/gin"
)

var (
	db                *gorm.DB
	ghAppClientID     = "Iv23lixO4VeZHg2cyuy4"
	ghAppClientSecret = "a44930b9c237ad5b34d8ac9e39d15a657ba1e983"
	ghOrg             = "lloyds-score"
	httpClient        = &http.Client{
		Timeout: 180 * time.Second, // Set a global timeout for all requests
	}
	cookieSecret = "secret"
	hmacKey      = "secret"
)

type Team struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

type GitHubTokenResponse struct {
	AccessToken           string `json:"access_token"`
	ExpiresIn             int    `json:"expires_in"`
	RefreshToken          string `json:"refresh_token"`
	RefreshTokenExpiresIn int    `json:"refresh_token_expires_in"`
	TokenType             string `json:"token_type"`
	Scope                 string `json:"scope"`
}

func main() {
	// // init database
	// initDB()

	r := gin.Default()

	// Middleware
	r.Use(cors.New(cors.Config{
		AllowOrigins:     []string{"http://localhost:5173"},
		AllowCredentials: true,
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Content-Type", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		MaxAge:           12 * time.Hour,
	}))
	store := cookie.NewStore([]byte(cookieSecret)) // REPLACE WITH ENV SECRET
	r.Use(sessions.Sessions("mysession", store))

	// Routes
	r.GET("/github/teams", getUsersGithubTeams)
	r.GET("/oauth/redirect", oauthRedirect)
	r.GET("/profile", getProfile)

	log.Fatal(r.Run(":8589"))
}

// func initDB() {
// 	var err error
// 	dsn := "host=localhost connect_timeout=10 user=postgres password=mysecretpassword dbname=postgres port=5432 sslmode=prefer TimeZone=Europe/London"
// 	db, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
// 	if err != nil {
// 		log.Fatal(err)
// 	}

// 	// Auto migrate the schema
// 	log.Println("Migrating database schema...")
// 	err = db.AutoMigrate(&RequestData{})
// 	if err != nil {
// 		log.Fatalf("Error migrating database: %v", err)
// 	}
// 	log.Println("Database schema migrated successfully")
// }


// getUsersGithubTeams gets teams for a user
func getUsersGithubTeams(c *gin.Context) {
	session := sessions.Default(c)
	token := session.Get("token")
	if token == nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized no token in request cookie"})
		return
	}

	req, err := http.NewRequest("GET", "https://api.github.com/user/teams", nil)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	req.Header.Set("Authorization", token.(string))

	resp, err := httpClient.Do(req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Error fetching teams from GitHub"})
		return
	}

	var teams []Team
	if err := json.NewDecoder(resp.Body).Decode(&teams); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, teams)
}


func oauthRedirect(c *gin.Context) {
	code := c.Query("code")
	if code == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Code query parameter is required"})
		return
	}

	ctx := context.Background()
	data := url.Values{
		"client_id":     {ghAppClientID},
		"client_secret": {ghAppClientSecret},
		"code":          {code},
	}
	req, err := http.NewRequestWithContext(ctx, "POST", "https://github.com/login/oauth/access_token", strings.NewReader(data.Encode()))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	req.Header.Set("Accept", "application/json")

	resp, err := httpClient.Do(req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	log.Printf("Response body: %s", body)

	if resp.StatusCode != http.StatusOK {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Error fetching access token from GitHub"})
		return
	}

	var tokenData GitHubTokenResponse
	if err := json.Unmarshal(body, &tokenData); err != nil {
		log.Printf("Error decoding response: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	req, err = http.NewRequest("GET", "https://api.github.com/user", nil)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	req.Header.Set("Authorization", tokenData.TokenType+" "+tokenData.AccessToken)

	userResp, err := httpClient.Do(req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	defer userResp.Body.Close()

	if userResp.StatusCode != http.StatusOK {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Error fetching user data from GitHub"})
		return
	}

	var userData interface{}
	if err := json.NewDecoder(userResp.Body).Decode(&userData); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	session := sessions.Default(c)
	session.Options(sessions.Options{
		MaxAge:   tokenData.ExpiresIn,
		HttpOnly: true,
		Secure:   true,
		Path:     "/",
		// SameSite:
	})
	session.Set("token", tokenData.TokenType+" "+tokenData.AccessToken)
	session.Save()

	c.JSON(http.StatusOK, gin.H{
		"userData":  userData,
		"expiresIn": tokenData.ExpiresIn,
	})
}

func getProfile(c *gin.Context) {
	session := sessions.Default(c)
	token := session.Get("token")
	if token == nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized no token in request cookie"})
		return
	}

	req, err := http.NewRequest("GET", "https://api.github.com/user", nil)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	req.Header.Set("Authorization", token.(string))

	resp, err := httpClient.Do(req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Error fetching user data from GitHub"})
		return
	}

	var userData interface{}
	if err := json.NewDecoder(resp.Body).Decode(&userData); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, userData)
}
