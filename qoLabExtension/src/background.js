import { createApiClientWithAuthHeader } from './popup/utils/apiClient';
global.browser = require('webextension-polyfill');
function getAccessToken() {
  return new Promise((resolve, reject) => {
    chrome.storage.sync.get(['access_token'], result => {
      if (!result) reject();
      resolve(result.access_token);
    });
  });
}

function getNowTabData() {
  return new Promise(resolve => {
    chrome.tabs.getSelected(tab => {
      resolve(tab);
    });
  });
}

function main() {
  setInterval(async () => {
    const token = await getAccessToken();
    if (token) {
      const api = createApiClientWithAuthHeader(token);
      const pageData = await getNowTabData();
      await api.post('user-activity', {
        activityName: 'browsing',
        data: pageData,
      });
    }
  }, 60000);
}

main();
