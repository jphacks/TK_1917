<template>
  <Promised :promise="asyncChartData">
    <template v-slot:pending>
      <v-progress-circular :size="50" color="primary" indeterminate />
    </template>
    <template v-slot="chartData">
      <v-layout column justify-center align-center>
        <v-flex xs12 sm8 md6>
          <div class="text-xs-center">
            <ChartPie :chart-data="chartData" :options="options" />
          </div>
        </v-flex>
      </v-layout>
    </template>
    <template v-slot:rejected="error">
      <span class="headline">😢ばぐっちゃった🙇‍</span>
    </template>
  </Promised>
</template>

<script>
import { Promised } from 'vue-promised'
import ChartPie from '@/components/ChartPie'
import api from '@/utils/apiClient'
import 'chartjs-plugin-colorschemes'

export default {
  components: {
    ChartPie,
    Promised
  },
  data() {
    return {
      asyncChartData: this.fetch(),
      options: {
        plugins: {
          colorschemes: {
            scheme: 'tableau.ClassicLight10'
          }
        },
        legend: {
          // 凡例設定
          display: true // 表示設定
        },
        title: {
          // タイトル設定
          display: true, // 表示設定
          fontSize: 18, // フォントサイズ
          text: 'Macアプリの使用時間割合（過去６時間）' // ラベル
        }
      }
    }
  },
  methods: {
    async fetch() {
      const res = await api.get('visialization/software')
      const activeAppData = res.data
      const datas = activeAppData
        .map(d => ({
          key: d.name,
          value: Math.floor(d.percentage)
        }))
        .sort((a, b) => b.value - a.value)
      const labels = datas.map(d => d.key)
      const data = datas.map(d => d.value)
      return {
        labels,
        datasets: [
          {
            data,
            borderWidth: 0.5
          }
        ]
      }
    }
  }
}
</script>
