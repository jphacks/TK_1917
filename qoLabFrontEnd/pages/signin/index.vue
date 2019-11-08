<template>
  <v-layout column justify-center align-center>
    <h2 class="loginText">ログイン</h2>
    <v-form
      ref="form"
      v-model="valid"
      :lazy-validation="lazy"
      class="loginForm"
      @submit.prevent="submit"
    >
      <v-text-field
        v-model="email"
        :rules="emailRules"
        label="E-mail"
        required
      ></v-text-field>
      <v-text-field
        v-model="password"
        :rules="passwordRules"
        type="password"
        label="Password"
        required
      ></v-text-field>
      <div class="loginButton">
        <v-btn
          v-if="!isLoading"
          :disabled="!valid"
          type="submit"
          class="button"
          color="primary"
          >ログイン</v-btn
        >
        <v-btn
          v-if="isLoading"
          :disabled="!valid || isLoading"
          type="submit"
          class="button"
          color="primary"
        >
          <v-progress-circular
            indeterminate
            color="primary"
          ></v-progress-circular>
        </v-btn>
      </div>
    </v-form>
    <div class="loginButton">
      <nuxt-link tag="div" class="signup-link" to="/signup"
        >登録はこちら</nuxt-link
      >
    </div>
  </v-layout>
</template>

<script>
import api from '@/utils/apiClient'

export default {
  data: () => ({
    valid: false,
    email: '',
    emailRules: [
      v => !!v || 'E-mail is required',
      v => /.+@.+\..+/.test(v) || 'E-mail must be valid'
    ],
    password: '',
    passwordRules: [
      v => !!v || 'Password is required',
      v => (v && v.length >= 8) || 'Password must be mote than 8 characters'
    ],
    lazy: false,
    isLoading: false
  }),
  methods: {
    submit: async function() {
      if (!this.valid) {
        return
      }
      this.isLoading = true
      try {
        const resp = await api.post('/signin', {
          email: this.email,
          password: this.password
        })
        localStorage.setItem('access_token', resp.data.access_token)
        this.$router.push('/')
      } catch (e) {
        this.isLoading = false
        console.debug('error')
      }
    }
  }
}
</script>

<style scoped>
.signup-link {
  color: #5c5c5c;
  cursor: pointer;
  margin-top: 20px;
}
.loginForm {
  width: 300px;
}
.loginButton {
  display: flex;
  justify-content: center;
  box-shadow: none;
}
.button {
  width: 100%;
  box-shadow: none;
}
.loginText {
  font-size: 16px;
  margin-bottom: 20px;
}
</style>
