<template>
  <Promised :promise="asyncChartData">
    <template v-slot:pending>
      <v-progress-circular :size="50" color="primary" indeterminate />
    </template>
    <template v-slot="chartData">
      <v-layout column justify-center align-center>
        <v-flex xs12 sm8 md6>
          <div class="text-xs-center">
            <Bar
              :height="450"
              :width="800"
              :chart-data="chartData"
              :options="options"
            />
          </div>
        </v-flex> </v-layout
    ></template>
    <template v-slot:rejected="error">
      <span class="headline">😢ばぐっちゃった🙇‍</span>
    </template>
  </Promised>
</template>

<script>
import { Promised } from 'vue-promised'
import Bar from '@/components/Bar'
import api from '@/utils/apiClient'

export default {
  components: {
    Bar,
    Promised
  },
  data() {
    return {
      asyncChartData: this.fetch(),
      options: {
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
          text: '過去6時間のドメイン別滞在時間（推定）' // ラベル
        }
      }
    }
  },
  methods: {
    async fetch() {
      const res = await api.get('visialization/browsing')
      const browsingData = res.data
      const domains = this.unique(browsingData.map(d => d.domain))
      const datas = domains
        .map(d => ({
          key: d,
          value: browsingData.filter(b => b.domain === d).length
        }))
        .sort((a, b) => b.value - a.value)
      const labels = datas.map(d => d.key)
      const data = datas.map(d => d.value)
      return {
        labels,
        datasets: [
          {
            data
          }
        ]
      }
    },
    unique(l) {
      return l.filter((x, i, self) => self.indexOf(x) === i)
    }
  }
}
</script>
