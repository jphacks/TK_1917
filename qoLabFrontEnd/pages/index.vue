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
            :v-if="browsingData1"
            :height="450"
            :width="800"
            :chart-data="browsingData1"
            :options="options"
          />
        </div>
        <div class="container">
          <LineChart
            :v-if="browsingData2"
            :height="450"
            :width="800"
            :chart-data="browsingData2"
            :options="options2"
          />
        </div>
        <div class="container">
          <LineChart
            :v-if="browsingData3"
            :height="450"
            :width="800"
            :chart-data="browsingData3"
            :options="options3"
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
    const temperatureIdx = res.data.findIndex(
      d => d[0].sensorName === 'PressureSensor'
    )
    const temphumIdx = res.data.findIndex(
      d => d[0].sensorName === 'TempHumSensor'
    )
    const data1 = res.data[temperatureIdx]
    const data2 = res.data[temphumIdx]
    return {
      browsingData1: {
        labels: data1.map(d => new Date(d.createdAt).toLocaleTimeString('ja')),
        datasets: [
          {
            data: data1.map(d => d.data.pressure)
          }
        ]
      },
      browsingData2: {
        labels: data2.map(d => new Date(d.createdAt).toLocaleTimeString('ja')),
        datasets: [
          {
            data: data2.map(d => d.data.temperature)
          }
        ]
      },
      browsingData3: {
        labels: data2.map(d => new Date(d.createdAt).toLocaleTimeString('ja')),
        datasets: [
          {
            data: data2.map(d => d.data.humidity)
          }
        ]
      },
      options: {
        plugins: {
          colorschemes: {
            scheme: 'brewer.PastelOne3'
          }
        },
        legend: {
          // 凡例設定
          display: false // 表示設定
        },
        title: {
          // タイトル設定
          display: true, // 表示設定
          fontSize: 18, // フォントサイズ
          text: '気圧(hPa)' // ラベル
        }
      },
      options2: {
        plugins: {
          colorschemes: {
            scheme: 'office.YellowOrange6'
          }
        },
        legend: {
          // 凡例設定
          display: false // 表示設定
        },
        title: {
          // タイトル設定
          display: true, // 表示設定
          fontSize: 18, // フォントサイズ
          text: '気温(℃)' // ラベル
        }
      },
      options3: {
        plugins: {
          colorschemes: {
            scheme: 'brewer.Paired12'
          }
        },
        legend: {
          // 凡例設定
          display: false // 表示設定
        },
        title: {
          // タイトル設定
          display: true, // 表示設定
          fontSize: 18, // フォントサイズ
          text: '湿度(%)' // ラベル
        }
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
