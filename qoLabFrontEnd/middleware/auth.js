import api from '@/utils/apiClient'

export default async function({ store, redirect }) {
  if (store.state.user.email) {
    return
  }

  try {
    const resp = await api.get('/me')
    if (resp.data) {
      // storeにdispatchしてそのまま
      store.dispatch('user/updateUser', resp.data)
    }
  } catch {
    redirect('/signin')
  }
}
