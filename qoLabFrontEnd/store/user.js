export const state = () => ({})

export const mutations = {
  updateUser(state, user) {
    Object.assign(state, { ...user })
  }
}

export const actions = {
  updateUser({ commit }, user) {
    commit('updateUser', user)
  }
}
