// @ts-ignore
import ReactRailsUJS from 'react_ujs';
// @ts-ignore
const componentRequireContext = require.context('app', true);
ReactRailsUJS.useContext(componentRequireContext);
