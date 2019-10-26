<template>
  <v-layout column justify-center align-center>
    <h2 class="display-2">ログイン</h2>
    <v-form ref="form" v-model="valid" :lazy-validation="lazy">
      <v-text-field
        v-model="email"
        :rules="emailRules"
        label="E-mail"
        required
      ></v-text-field>
      <v-text-field
        v-model="password"
        :rules="emailRules"
        label="Password"
        required
      ></v-text-field>
      <v-btn class="mr-4" color="primary" @click="submit">ログイン</v-btn>
    </v-form>
  </v-layout>
</template>

<script>
export default {
  data: () => ({
    valid: true,
    name: '',
    nameRules: [
      v => !!v || 'Name is required',
      v => (v && v.length <= 10) || 'Name must be less than 10 characters'
    ],
    email: '',
    emailRules: [
      v => !!v || 'E-mail is required',
      v => /.+@.+\..+/.test(v) || 'E-mail must be valid'
    ],
    password: '',
    select: null,
    items: ['Item 1', 'Item 2', 'Item 3', 'Item 4'],
    checkbox: false,
    lazy: false
  }),
  methods: {
    submit: function() {
      console.debug('a')
    }
  }
}
</script>
