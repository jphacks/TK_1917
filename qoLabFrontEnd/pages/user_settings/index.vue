<template>
  <v-layout column justify-center align-center>
    <h2 class="text">ユーザー設定</h2>
    <v-form
      ref="form"
      v-model="valid"
      :lazy-validation="lazy"
      class="form"
      @submit.prevent="submit"
    >
      <v-text-field
        v-model="name"
        :rules="nameRules"
        label="your name"
        required
      ></v-text-field>
      <div class="submitButton">
        <v-btn
          v-if="!this.isLoading"
          :disabled="!valid"
          type="submit"
          class="button"
          color="primary"
          >設定</v-btn
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
  </v-layout>
</template>

<script>
import api from '@/utils/apiClient'

export default {
  data: () => ({
    valid: false,
    name: '',
    nameRules: [v => !!v || 'E-mail is required'],
    isLoading: false,
    lazy: false
  }),
  methods: {
    submit: async function() {
      if (!this.valid) {
        return
      }
      this.isLoading = true
      try {
        const resp = await api.put('/me', {
          name: this.name
        })
        this.$store.dispatch('user/updateUser', resp.data)
        this.$router.push('/')
      } catch (e) {
        console.debug('error')
      } finally {
        this.isLoading = false
      }
    }
  }
}
</script>

<style scoped>
.form {
  width: 300px;
}
.submitButton {
  display: flex;
  justify-content: center;
  box-shadow: none;
}
.button {
  width: 100%;
  box-shadow: none;
}
.text {
  font-size: 16px;
  margin-bottom: 20px;
}
</style>
