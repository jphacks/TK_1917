<template>
  <Promised :promise="asyncChartData">
    <template v-slot:pending>
      <v-progress-circular :size="50" color="primary" indeterminate />
    </template>
    <template v-slot="payloads">
      <ChartLine
        v-for="payload in payloads"
        :key="payload._id"
        :chart-data="convertChartData(payload)"
        :heigth="450"
        :width="800"
        :options="options"
      />
    </template>
    <template v-slot:rejected="error">
      <span class="headline">😢ばぐっちゃった🙇‍</span>
    </template>
  </Promised>
</template>

<script>
import { Promised } from 'vue-promised'
import { format } from 'date-fns'
import ChartLine from '@/components/ChartLine'

import api from '@/utils/apiClient'
export default {
  components: {
    Promised,
    ChartLine
  },
  props: {
    sensorName: {
      required: true,
      type: String
    },
    options: {
      type: Object,
      default() {
        return {
          plugins: {
            colorschemes: {
              scheme: 'tableau.ClassicLight10'
            }
          }
        }
      }
    }
  },
  data() {
    return {
      asyncChartData: null
    }
  },
  watch: {
    sensorName(val) {
      this.asyncChartData = this.fetch()
    }
  },
  methods: {
    async fetch() {
      const res = await api.get(`visialization/envdata/${this.sensorName}`)
      const data = res.data
      return data.sensorData
    },
    convertChartData(payload) {
      return {
        labels: payload.map(d => format(new Date(d.createdAt), 'HH時mm分ss秒')),
        datasets: [
          {
            data: payload.map(d => d.data)
          }
        ]
      }
    }
  }
}
</script>
