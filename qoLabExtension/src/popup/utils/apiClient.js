import axios from 'axios';

const apiClient = () => {
  const defaultOptions = {
    baseURL: 'https://qolab-api.herokuapp.com',
    headers: {
      'Content-Type': 'application/json',
    },
  };

  // Create instance
  const instance = axios.create(defaultOptions);

  return instance;
};

export const createApiClientWithAuthHeader = token => {
  const api = apiClient();

  // Set the AUTH token for any request
  api.interceptors.request.use(function(config) {
    config.headers.Authorization = token ? `Bearer ${token}` : '';
    return config;
  });

  return api;
};

export default apiClient();
