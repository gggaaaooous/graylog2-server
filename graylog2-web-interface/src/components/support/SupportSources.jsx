import React from 'react';

import { Icon } from 'components/common';
import DocumentationLink from './DocumentationLink';
import DocsHelper from '../../util/DocsHelper';

const SupportSources = () => (
  <div className="support-sources">
    <h2>Need help?</h2>
    <p>
      Do not hesitate to consult the Graylog community if your questions are not answered in the{' '}
      <DocumentationLink page={DocsHelper.PAGES.WELCOME} text="documentation" />.
    </p>

    <ul>
      <li>
        <Icon name="group" />&nbsp;
        <a href="https://www.graylog.org/community-support/" target="_blank" rel="noopener noreferrer">Community support</a>
      </li>
      <li>
        <Icon name="github-alt" />&nbsp;
        <a href="https://github.com/Graylog2/graylog2-server/issues" target="_blank" rel="noopener noreferrer">Issue tracker</a>
      </li>
      <li>
        <Icon name="heart" />&nbsp;
        <a href="https://www.graylog.org/professional-support" target="_blank" rel="noopener noreferrer">Professional support</a>
      </li>
    </ul>
  </div>
);

SupportSources.propTypes = {};

export default SupportSources;
