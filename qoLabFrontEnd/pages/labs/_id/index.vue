<template>
  <v-layout column justify-center class="container">
    <h2 class="display-2 label">研究室の管理</h2>
    <div v-for="room in rooms" :key="room._id" class="list">
      <div class="room-label">{{ room.name }}</div>
      <v-select :items="monipis" label="モニパイ" solo></v-select>
    </div>
  </v-layout>
</template>

<script>
// import api from '@/utils/apiClient'

export default {
  data() {
    return {
      rooms: [{ _id: '001', name: '805' }, { _id: '002', name: '806' }],
      monipis: ['001', '002']
    }
  },
  mounted() {},
  methods: {
    submit: function() {}
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
</style>
