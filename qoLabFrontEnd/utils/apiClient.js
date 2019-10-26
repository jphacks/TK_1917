import axios from 'axios'

const apiClient = () => {
  const defaultOptions = {
    baseURL: 'https://qolab-api.herokuapp.com',
    headers: {
      'Content-Type': 'application/json'
    }
  }

  // Create instance
  const instance = axios.create(defaultOptions)

  // Set the AUTH token for any request
  instance.interceptors.request.use(function(config) {
    const token = localStorage.getItem('token')
    config.headers.Authorization = token ? `Bearer ${token}` : ''
    return config
  })

  return instance
}

export default apiClient()
