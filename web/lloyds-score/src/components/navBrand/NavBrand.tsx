import { Navbar } from 'react-bootstrap';
import loginLogo from '../../assets/logo.jpeg';

const NavBrand = () => {
    return (
        <Navbar.Brand className="text-light fw-bold">
        <img
          alt="Login Logo"
          src={loginLogo}
          width="30"
          height="30"
          className="me-2"
        />
        Lloyds Score
      </Navbar.Brand>
    );
};

export default NavBrand;
