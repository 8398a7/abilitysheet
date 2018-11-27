import * as React from 'react';
import { Helmet } from 'react-helmet';

const HelmetWrapper: React.SFC<{ mobile: boolean }> = (props) => (
  <Helmet>
     <meta name="viewport" content={`${props.mobile ? 'width=device-width, initial-scale=1' : ''}`} />
  </Helmet>
);

export default HelmetWrapper;
