import { Record } from 'immutable';
import queryString from 'query-string';

function implicitMobile() {
  const u = window.navigator.userAgent.toLowerCase();
  return (
    (u.indexOf('windows') !== -1 && u.indexOf('phone') !== -1) ||
    u.indexOf('iphone') !== -1 ||
    u.indexOf('ipod') !== -1 ||
    (u.indexOf('android') !== -1 && u.indexOf('mobile') !== -1) ||
    (u.indexOf('firefox') !== -1 && u.indexOf('mobile') !== -1) ||
    u.indexOf('blackberry') !== -1
  );
}
const defaultValue = {
  FC: 0,
  EXH: 1,
  HARD: 2,
  CLEAR: 3,
  EASY: 4,
  ASSIST: 5,
  FAILED: 6,
  NOPLAY: 7,
  color: [
    '#ff8c00',
    '#ffd900',
    '#ff6347',
    '#afeeee',
    '#98fb98',
    '#9595ff',
    '#c0c0c0',
    '#ffffff',
  ],
  implicitMobile: implicitMobile(),
  explicitDesktop: false,
};

export default class Environment extends Record(defaultValue) {
  public mobileView() {
    if (this.explicitDesktop) {
      return false;
    }
    return this.implicitMobile;
  }

  public considerQueryString() {
    const query = queryString.parse(location.search);
    if (!query.device) {
      return this;
    }
    return this.set('explicitDesktop', query.device === 'pc');
  }

  public toggleViewport() {
    const url = location.origin + location.pathname;
    const query = queryString.parse(location.search);
    if (this.explicitDesktop) {
      delete query.device;
      history.replaceState(
        '',
        '',
        `${url}?${queryString.stringify({ ...query })}`,
      );
    } else {
      history.replaceState(
        '',
        '',
        `${url}?${queryString.stringify({ ...query, device: 'pc' })}`,
      );
    }
    return this.set('explicitDesktop', !this.explicitDesktop);
  }
}
