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
          <TheSelectSensorName @change="change" />
          <TheBarEnv :sensor-name="sensorName" :options="pressureChartOption" />
        </div>
      </div>
    </v-flex>
  </v-layout>
</template>

<script>
import TheBarDomain from '@/components/TheBarDomain'
import ThePieUseAppRate from '@/components/ThePieUseAppRate'
import TheLineKey from '@/components/TheLineKey'
import TheBarEnv from '@/components/TheBarEnv'
import TheSelectSensorName from '@/components/TheSelectSensorName'

const pressureChartOption = {
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

const humiChartOption = {
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
const tempChartOption = {
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
export default {
  middleware: 'auth',
  components: {
    TheBarDomain,
    ThePieUseAppRate,
    TheLineKey,
    TheBarEnv,
    TheSelectSensorName
  },
  data() {
    return {
      pressureChartOption,
      tempChartOption,
      humiChartOption,
      sensorName: null
    }
  },
  computed: {
    user() {
      return this.$store.state.user
    }
  },
  methods: {
    change(s) {
      this.sensorName = s
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
