<template>
  <Promised :promise="asyncSelectItems">
    <template v-slot:pending>
      <v-progress-circular :size="50" color="primary" indeterminate />
    </template>
    <template v-slot="items">
      <v-select
        :items="items"
        label="センサーを選んでください"
        @input="changeEvent"
      />
    </template>
    <template v-slot:rejected="error">
      {{ error.message }}
    </template>
  </Promised>
</template>

<script>
import { Promised } from 'vue-promised'
import api from '@/utils/apiClient'
export default {
  components: {
    Promised
  },
  data() {
    return {
      asyncSelectItems: this.fetch()
    }
  },
  methods: {
    async fetch() {
      const res = await api.get('visialization/sensor_category')
      return res.data
    },
    changeEvent(e) {
      console.log(e)
      this.$emit('change', e)
    }
  }
}
</script>
