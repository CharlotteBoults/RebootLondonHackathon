
import { Tab } from 'react-bootstrap';

const HomeTabPane = () => {
    return (
        <>
        <Tab.Pane eventKey="home" className="text-start py-4">
            <p>Welcome to Lloyds score</p>
        </Tab.Pane>
        </>
    );
};

export default HomeTabPane;
