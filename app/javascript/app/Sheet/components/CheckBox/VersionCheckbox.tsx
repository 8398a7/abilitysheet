import * as queryString from 'query-string';
import * as React from 'react';
import { connect } from 'react-redux';
import { bindActionCreators, Dispatch } from 'redux';
import { RootState } from '../../ducks';
import { actions } from '../../ducks/Sheet';

function mapStateToProps(state: RootState) {
  return {
    versions: state.$$sheet.versions,
  };
}
function mapDispatchToProps(dispatch: Dispatch) {
  const { toggleVersion, reverseAbilities } = actions;
  return bindActionCreators({ toggleVersion, reverseAbilities }, dispatch);
}
type Props = ReturnType<typeof mapStateToProps> & ReturnType<typeof mapDispatchToProps>;

class VersionCheckbox extends React.PureComponent<Props, { reverse: boolean }> {
  public state = {
    reverse: false,
  };

  public componentWillMount() {
    const query = queryString.parse(location.search);
    if (query.reverse_sheet === 'true') {
      this.handleChangeReverse();
    }
  }

  public onChangeReverseState() {
    this.setState({ reverse: !this.state.reverse });
  }

  public handleToggleVersion = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { toggleVersion, versions } = this.props;
    if (e.target.value === '0') {
      versions.forEach(version => {
        const targetInput = document.querySelector<HTMLInputElement>(`input[name="version-check"][value="${version[1]}"]`);
        if (targetInput) {
          targetInput.checked = !targetInput.checked;
        }
        toggleVersion(version[1]);
      });
    } else {
      toggleVersion(parseInt(e.target.value, 10));
    }
  }

  public handleChangeReverse = () => {
    const { reverse } = this.state;
    const query = queryString.parse(location.search);
    const url = location.origin + location.pathname;
    if (reverse === false && query.reverse_sheet === undefined) {
      history.replaceState('', '', `${url}?${queryString.stringify({ ...query, reverse_sheet: true })}`);
    } else if (reverse === true && query.reverse_sheet) {
      delete(query.reverse_sheet);
      history.replaceState('', '', `${url}?${queryString.stringify({ ...query })}`);
    }
    this.setState({ reverse: !reverse });
    this.props.reverseAbilities();
  }

  public renderVersionCheckbox() {
    const dom: JSX.Element[] = [];
    this.props.versions.forEach(version => {
      if (version[1] === 0) {
        dom.push(<label key={`version-checkbox-${version}`}>
            <input type="checkbox" value={version[1]} name="all-version-check" defaultChecked={true} onChange={this.handleToggleVersion} />
            {version[0]}
          </label>);
        return null;
      }
      dom.push(<label key={`version-checkbox-${version}`}>
          <input type="checkbox" value={version[1]} name="version-check" defaultChecked={true} onChange={this.handleToggleVersion} />
          {version[0]}
        </label>);
    });
    dom.push(<label key="version-checkbox-reverse">
        <input type="checkbox" value="0" name="reverse" checked={this.state.reverse} onChange={this.handleChangeReverse} />
        逆順表示
      </label>);
    return dom;
  }

  public render() {
    return (
      <div className="version-checkbox">
        {this.renderVersionCheckbox()}
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(VersionCheckbox);
