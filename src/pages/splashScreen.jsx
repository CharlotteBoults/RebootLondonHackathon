import Card from "../components/Card";
import React, { useEffect } from "react";
import { Heading } from "../components/Typography";
import { animated } from "react-spring";
import useFadeInOnLoad from "../hooks/useFadeInOnLoad";
import { useNavigate } from "react-router-dom";

export const SplashScreen = () => {
  const fadeIn = useFadeInOnLoad();
  const navigate = useNavigate();

  useEffect(() => {
    const time = setTimeout(() => {
      navigate("/topics");
    }, 1500);
    return () => clearTimeout(time);
  }, [navigate]);

  return (
    <animated.div style={fadeIn}>
      <Card>
        <Heading>Welcome! </Heading>
      </Card>
    </animated.div>
  );
};
