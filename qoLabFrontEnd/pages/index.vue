<template>
  <v-layout column justify-center align-center>
    <div v-if="user.name != null" class="name">{{ user.name }}のログデータ</div>
    <v-flex xs12 sm8 md6>
      <div class="text-xs-center">
        <div class="container">
          <TheBarDomain />
        </div>
        <div class="container">
          <ThePieUseAppRate />
        </div>
        <div class="container">
          <TheLineKey />
        </div>
        <div class="container">
          <TheBarEnv sensor-name="pressure" />
        </div>
        <div class="container">
          <TheBarEnv sensor-name="temperature" />
        </div>
        <div class="container">
          <TheBarEnv sensor-name="humidity" />
        </div>
        <!-- <div v-if="labName">
          <p class="labname">{{ labName }}の室内環境</p>
          <div v-if="!!browsingData1" class="container">
            <LineChart
              :height="450"
              :width="800"
              :chart-data="browsingData1"
              :options="options"
            />
          </div>
          <div v-if="!!browsingData2" class="container">
            <LineChart
              :height="450"
              :width="800"
              :chart-data="browsingData2"
              :options="options2"
            />
          </div>
          <div v-if="browsingData3" class="container">
            <LineChart
              :height="450"
              :width="800"
              :chart-data="browsingData3"
              :options="options3"
            />
          </div>
        </div> -->
      </div>
    </v-flex>
  </v-layout>
</template>

<script>
import TheBarDomain from '@/components/TheBarDomain'
import ThePieUseAppRate from '@/components/ThePieUseAppRate'
import TheLineKey from '@/components/TheLineKey'
import api from '@/utils/apiClient'

import TheBarEnv from '@/components/TheBarEnv'

export default {
  middleware: 'auth',
  components: {
    TheBarDomain,
    ThePieUseAppRate,
    TheLineKey,
    TheBarEnv
  },
  data() {
    return {
      browsingData1: null,
      browsingData2: null,
      browsingData3: null,
      option1: null,
      option2: null,
      option3: null
    }
  },
  computed: {
    user() {
      return this.$store.state.user
    }
  },
  async created() {
    try {
      const res = await api.get('visialization/envdata')
      const temperatureIdx = res.data.findIndex(
        d => d[0].sensorName === 'PressureSensor'
      )
      const temphumIdx = res.data.findIndex(
        d => d[0].sensorName === 'TempHumSensor'
      )
      const data1 = res.data[temperatureIdx]
      const data2 = res.data[temphumIdx]
      this.browsingData1 = {
        labels: data1.map(d => new Date(d.createdAt).toLocaleTimeString('ja')),
        datasets: [
          {
            data: data1.map(d => d.data.pressure)
          }
        ]
      }
      this.browsingData2 = {
        labels: data2.map(d => new Date(d.createdAt).toLocaleTimeString('ja')),
        datasets: [
          {
            data: data2.map(d => d.data.temperature)
          }
        ]
      }
      this.browsingData3 = {
        labels: data2.map(d => new Date(d.createdAt).toLocaleTimeString('ja')),
        datasets: [
          {
            data: data2.map(d => d.data.humidity)
          }
        ]
      }
      this.options1 = {
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
      }
      this.options2 = {
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
          text: '湿度(%)' // ラベル
        }
      }
      this.options3 = {
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
          text: '気温(℃)' // ラベル
        }
      }
    } catch (e) {
      console.error(e)
    }
  }
}
</script>

<style>
.container {
  margin: 30px auto;
}
.labname {
  font-size: 18px;
  font-weight: bold;
}
.name {
  font-size: 18px;
  font-weight: bold;
  text-align: left;
}
</style>
