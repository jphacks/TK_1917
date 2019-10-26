<template>
  <div class="container">
    <h2>ログイン</h2>
    <form @submit.prevent="login">
      <div class="input-form">
        <label for="email">Email</label>
        <input type="email" name="email" v-model="email" />
      </div>
      <div class="input-form">
        <label for="password">Password</label>
        <input type="password" name="password" v-model="password" />
      </div>
      <input type="submit" class="submit-button" />
    </form>
  </div>
</template>

<script>
import router from 'vue-router';
import api, { createApiClientWithAuthHeader } from '../../utils/apiClient';
export default {
  data() {
    return {
      email: '',
      password: '',
    };
  },
  methods: {
    login: async function() {
      try {
        const resp = await api.post('/signin', {
          email: this.email,
          password: this.password,
        });
        chrome.storage.sync.set({ access_token: resp.data.access_token });
        this.$router.push('/');
      } catch {
        console.debug('error');
      }
    },
  },
};
</script>

<style lang="scss" scoped>
.input-form {
  display: flex;
  justify-content: flex-start;
  align-items: center;
  margin: 0 auto 16px;
}

.submit-button {
  float: right;
}

label {
  width: 60px;
}

.container {
  padding: 0 16px 24px 16px;
}
</style>
