<template>
  <v-layout column justify-center align-center>
    <h2 class="display-2">登録</h2>
    <v-form ref="form" v-model="valid" :lazy-validation="lazy">
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
        <v-btn type="submit" class="mr-4" color="primary" @click="submit"
          >登録</v-btn
        >
      </div>
    </v-form>
    <nuxt-link tag="div" class="signup-link" to="/signin">
      ログインはこちら</nuxt-link
    >
  </v-layout>
</template>

<script>
export default {
  data: () => ({
    valid: true,
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
    submit: function() {
      if (this.valid) {
        return
      }
      console.debug('a')
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
