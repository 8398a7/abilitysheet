import React, { SFC } from 'react';
import { Helmet } from 'react-helmet';

const HelmetWrapper: SFC<{ mobile: boolean }> = (props) => (
  <Helmet>
    <meta
      name="viewport"
      content={`${props.mobile ? 'width=device-width, initial-scale=1' : ''}`}
    />
  </Helmet>
);

export default HelmetWrapper;
