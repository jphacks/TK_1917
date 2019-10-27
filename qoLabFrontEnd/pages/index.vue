<template>
  <v-layout column justify-center align-center>
    <v-flex xs12 sm8 md6>
      <div class="text-xs-center">
        <div class="container">
          <DomainChart />
        </div>
        <div class="container">
          <AppChart />
        </div>
        <div class="container">
          <KeyChart />
        </div>
        <div class="container">
          <LineChart
            :v-if="data"
            :height="450"
            :width="800"
            :chart-data="browsingData1"
            :options="options"
          />
          <LineChart
            :v-if="data"
            :height="450"
            :width="800"
            :chart-data="browsingData2"
          />
        </div>
      </div>
    </v-flex>
  </v-layout>
</template>

<script>
import DomainChart from '@/components/DomainChart'
import AppChart from '@/components/AppChart'
import KeyChart from '@/components/KeyChart'
import api from '@/utils/apiClient'
import LineChart from '@/components/LineChart'

export default {
  middleware: 'auth',
  components: {
    DomainChart,
    AppChart,
    KeyChart,
    LineChart
  },
  async asyncData() {
    const res = await api.get('visialization/envdata')
    const data1 = res.data[3]
    const data2 = res.data[2]
    return {
      browsingData1: {
        labels: data1.map(d => d.createdAt),
        datasets: [
          {
            data: data1.map(d => d.data.pressure)
          }
        ]
      },
      browsingData2: {
        labels: data2.map(d => d.createdAt),
        datasets: [
          {
            data: data2.map(d => d.data.temperature)
          },
          {
            data: data2.map(d => d.data.humidity)
          }
        ]
      }
    }
  }
}
</script>

<style>
.container {
  margin: 30px auto;
}
</style>
