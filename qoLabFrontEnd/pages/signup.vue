<template>
  <v-layout column justify-center align-center>
    <h2 class="register">登録</h2>
    <v-form
      ref="form"
      v-model="valid"
      :lazy-validation="lazy"
      class="registerForm"
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
        label="Password"
        type="password"
        required
      ></v-text-field>
      <div class="registerButton">
        <v-btn
          v-if="!this.isLoading"
          :disabled="!valid"
          type="submit"
          class="button"
          color="primary"
          >登録</v-btn
        >
        <v-btn
          v-if="this.isLoading"
          :disabled="!valid || this.isLoading"
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
    <nuxt-link tag="div" class="signup-link" to="/signin"
      >ログインはこちら</nuxt-link
    >
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
        const resp = await api.post('/signup', {
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
.registerForm {
  width: 300px;
}
.registerButton {
  display: flex;
  justify-content: center;
  box-shadow: none;
}
.button {
  width: 100%;
  box-shadow: none;
}
.register {
  font-size: 16px;
  margin-bottom: 20px;
}
</style>
