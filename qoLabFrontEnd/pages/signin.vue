<template>
  <v-layout column justify-center align-center>
    <h2 class="display-2">ログイン</h2>
    <v-form
      ref="form"
      v-model="valid"
      :lazy-validation="lazy"
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
        required
      ></v-text-field>
      <div>
        <v-btn type="submit" class="mr-4" color="primary">ログイン</v-btn>
      </div>
    </v-form>
    <nuxt-link tag="div" class="signup-link" to="/signup"
      >登録はこちら</nuxt-link
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
    lazy: false
  }),
  methods: {
    submit: async function() {
      if (!this.valid) {
        return
      }

      try {
        const resp = await api.post('/signin', {
          email: this.email,
          password: this.password
        })
        localStorage.setItem('access_token', resp.data.access_token)
        this.$router.push('/')
      } catch (e) {
        console.debug('error')
      }
    }
  }
}
</script>

<style scoped>
.signup-link {
  color: white;
  cursor: pointer;
}
</style>
