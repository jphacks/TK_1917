<template>
  <Promised :promise="asyncChartData">
    <template v-slot:pending>
      <v-progress-circular :size="50" color="primary" indeterminate />
    </template>
    <template v-slot="chartData">
      <ChartLine :chart-data="chartData" :heigth="450" :width="800" />
    </template>
    <template v-slot:rejected="error">
      <span class="headline">😢ばぐっちゃった🙇‍</span>
    </template>
  </Promised>
</template>

<script>
import { Promised } from 'vue-promised'
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
      asyncChartData: this.fetch()
    }
  },
  methods: {
    async fetch() {
      const res = await api.get('visialization/envdata')
      const idx = res.data.findIndex(d =>
        d[0].sensorName.includes(this.sensorName)
      )
      const data = res.data[idx]
      return {
        labels: data.map(d => new Date(d.createdat)),
        datasets: [
          {
            data: data.map(d => d.data[this.sensorName])
          }
        ]
      }
    }
  }
}
</script>
