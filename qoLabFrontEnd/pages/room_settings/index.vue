<template>
  <v-layout column justify-center class="container">
    <h2 class="label">部屋の作成</h2>
    <v-form ref="form" @submit.prevent="submit">
      <v-text-field
        v-model="roomName"
        label="新しく追加する部屋名"
        required
      ></v-text-field>
      <div>
        <v-btn
          :disabled="this.roomName == null || this.roomName.length <= 0"
          type="submit"
          class="button"
          color="primary"
          >部屋を作成</v-btn
        >
      </div>
    </v-form>
  </v-layout>
</template>

<script>
import api from '@/utils/apiClient'

export default {
  middleware: 'auth',
  data: () => ({
    valid: false,
    roomName: ''
  }),
  methods: {
    submit: async function() {
      if (this.roomName == null || this.roomName.length <= 0) {
        return
      }

      try {
        await api.post('/room', {
          name: this.roomName
        })
        this.roomName = ''
      } catch (e) {
        console.debug('error')
      }
    }
  }
}
</script>

<style scoped>
.container {
  width: 500px;
}
.label {
  font-size: 18px;
}
</style>
