<template>
  <v-layout column justify-center class="container">
    <h2 class="display-2 label">研究室の管理</h2>
    <div v-for="room in rooms" :key="room._id" class="list">
      <div>
        <div class="room-label">{{ room.name }}</div>
        <p>現在のモニパイID: {{ room.monipiId }}</p>
      </div>
      <v-select
        item-text="monipiCode"
        item-value="_id"
        :items="monipis"
        label="モニパイ"
        solo
        @change="e => submit(room._id, e)"
      ></v-select>
      <v-btn
        class="submit-btn"
        color="primary"
        @click="submit(room._id, monipi._Id)"
        >更新する</v-btn
      >
    </div>
  </v-layout>
</template>

<script>
import api from '@/utils/apiClient'

export default {
  middleware: 'auth',
  data() {
    return {
      rooms: [],
      monipis: [],
      selectedData: null
    }
  },
  mounted: async function() {
    try {
      const resp = await api.get('/room')
      this.rooms = resp.data
    } catch {
      console.debug('error')
    }

    try {
      const resp = await api.get('/monipi')
      this.monipis = resp.data
    } catch {
      console.debug('error')
    }
  },
  methods: {
    submit: async function(roomId, monipiId) {
      try {
        await api.put('/room', {
          _id: roomId,
          monipiId: monipiId
        })
      } catch {
        console.debug('monipi error')
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
  margin-bottom: 24px;
}

.list {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 76px;
}

.room-label {
  height: 76px;
  font-size: 32px;
  line-height: 52px;
  margin-right: 16px;
  vertical-align: middle;
}

.submit-btn {
  display: block;
}
</style>
