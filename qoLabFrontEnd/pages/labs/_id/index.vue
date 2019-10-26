<template>
  <v-layout column justify-center class="container">
    <h2 class="display-2 label">研究室の管理</h2>
    <div v-for="room in rooms" :key="room._id" class="list">
      <div class="flex">
        <div class="room-label">{{ room.name }}</div>
        <v-select
          class="monipi-selector"
          item-text="_id"
          item-value="_id"
          :items="monipis"
          label="モニパイ"
          solo
          @change="e => submit(room._id, e)"
        ></v-select>
      </div>
      <p>現在のモニパイId: {{ room.monipiId }}</p>
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

        const updatedRoom = this.rooms.filter(r => r._id === roomId)
        console.debug(updatedRoom)
        updatedRoom[0].monipiId = monipiId
      } catch {
        console.debug('monipi error')
      }
    }
  }
}
</script>

<style scoped>
.container {
  width: 1000px;
}

.label {
  margin-bottom: 8px;
}

.flex {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 900px;
}

.list {
  margin-bottom: 32px;
}

.monipi-selector {
  width: 600px;
}

.room-label {
  width: 200px;
  height: 76px;
  font-size: 32px;
  line-height: 52px;
  margin-right: 16px;
  vertical-align: middle;
}
</style>
