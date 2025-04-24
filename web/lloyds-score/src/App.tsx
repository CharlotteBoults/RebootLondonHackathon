import lloydsScoreLogo from './assets/logo.jpeg'
import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import "./App.css";
import Profile from "./components/profile/Profile";
import Login from "./components/login/Login";
import { Card, Nav, Tab } from "react-bootstrap";
import axios from "axios";
import { SyncLoader } from "react-spinners";
import Container from 'react-bootstrap/Container';
import HomeTabPane from './components/home/HomeTabPane';

type ApiResponse = {
    userData: UserData;
    expiresIn: number;
};

type UserData = {
    avatar_url: string;
    login: string;
    id: string;
    type: string;
};

function App() {
    const urlParams = new URLSearchParams(window.location.search);
    const code = urlParams.get("code");
    const [data, setData] = useState<ApiResponse | null>(null);
    const [loading, setLoading] = useState(false);
	  const [login, setLogin] = useState(false);
    const [activeTab, setActiveTab] = useState<string>('request');
    const navigate = useNavigate();

    useEffect(() => {
        const tokenExpiry = localStorage.getItem("tokenExpiry");

		if (code) {
            setLoading(true);
            fetch(`http://localhost:8589/oauth/redirect?code=${code}&state=YOUR_RANDOMLY_GENERATED_STATE`, {
                credentials: 'include'
            })
            .then((res) => res.json())
            .then((data: ApiResponse) => {
                if (data && data.userData) {
                    setData(data);
                    localStorage.setItem(
                        "tokenExpiry",
                        new Date(new Date().getTime() + data.expiresIn * 1000).toString()
                    );
                    // Clear the URL parameters
                    navigate(window.location.pathname);
                } else {
                    console.error("Invalid data structure:", data);
                }
                setLoading(false);
            })
            .catch((error) => {
                console.error("Error fetching data:", error);
                setLoading(false);
				setLogin(true);
            });
        } else if (tokenExpiry && new Date(tokenExpiry) > new Date()) {
            setLoading(true);
            fetch("http://localhost:8589/profile", {
                credentials: 'include'
            })
            .then((res) => {
                if (res.ok) {
                    return res.json();
                } else {
                    throw new Error('Not logged in');
                }
            })
            .then((profileData) => {
                if (profileData && profileData.login) {
                    setData({
                        userData: profileData,
                        expiresIn: 0 // unused in profile fetch
                    });
                    // Clear the URL parameters
                    navigate(window.location.pathname);
                } else {
                    console.error("Invalid profile data structure:", profileData);
                }
                setLoading(false);
            })
            .catch((error) => {
                console.error("Error fetching profile data:", error);
                setLoading(false);
				setLogin(true);
            });
        } else {
			setLogin(true);
		}
    }, [code, navigate]);


	if (loading) {
		return (
			<div className="loader-container">
				<SyncLoader
					color="#0494ba"
					size={20}
				/>
			</div>
		);
	}


    if (data && data.userData) {
        return (
            <div>
                <Profile user={data.userData} />
                <Card className="d-flex justify-content-center align-items-start">
                    <Card.Body className="container">
                        <Tab.Container id="left-tabs-example" activeKey={activeTab} onSelect={(selectedKey) => setActiveTab(selectedKey || 'request')}>
                            <Nav variant="tabs">
                                <Nav.Item>
                                    <Nav.Link href="#home" eventKey="home">Home</Nav.Link>
                                </Nav.Item>
                                <Nav.Item>
                                    <Nav.Link href="#whatsHot" eventKey="whatsHot">Whats Hot</Nav.Link>
                                </Nav.Item>
                                <Nav.Item>
                                    <Nav.Link href="#leaderboard" eventKey="leaderboard">Leaderboard</Nav.Link>
                                </Nav.Item>
                                <Nav.Item>
                                    <Nav.Link href="#feed" eventKey="feed">Feed</Nav.Link>
                                </Nav.Item>
                            </Nav>
                            <Tab.Content>
                            <HomeTabPane
                                    activeTab={activeTab}
                                    userId={data.userData.id}
                                />
                            </Tab.Content>
                        </Tab.Container>
                    </Card.Body>
                </Card>
            </div>
        );
    } else if (login) {
		return (
			<div>
				<Login />
			</div>
		);
	}
}

export default App;
