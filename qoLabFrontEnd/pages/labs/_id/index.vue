<template>
  <v-layout column justify-center class="container">
    <h2 class="display-2 label">slackの連携</h2>
    <v-form ref="form" v-model="valid" @submit.prevent="updateSlackConfig">
      <v-text-field
        v-model="url"
        :rules="urlRules"
        label="webhook comming URL"
        required
      ></v-text-field>
      <v-text-field
        v-model="channel"
        :rules="channelRules"
        label="チャンネル名"
        required
      ></v-text-field>
      <div>
        <v-btn :disabled="!valid" type="submit" class="mr-4" color="primary"
          >slack通知を設定</v-btn
        >
      </div>
    </v-form>
    <span class="line"></span>
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
      valid: false,
      url: '',
      urlRules: [v => !!v || 'URL is required'],
      channel: '',
      channelRules: [v => !!v || 'Channel Name is required']
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
    },
    updateSlackConfig: async function() {
      try {
        await api.post('/slack-config', {
          url: this.url,
          channel: this.channel
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

.line {
  margin: 32px 0;
  border-bottom: 1px solid #ffffff;
}
</style>
