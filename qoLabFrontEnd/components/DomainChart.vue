<template>
  <v-layout column justify-center align-center>
    <v-flex xs12 sm8 md6>
      <div class="text-xs-center">
        <Bar
          v-if="browsingData"
          :height="450"
          :width="800"
          :chart-data="browsingData"
          :options="options"
        />
      </div>
    </v-flex>
  </v-layout>
</template>

<script>
import Bar from '@/components/Bar'
import api from '@/utils/apiClient'

export default {
  components: {
    Bar
  },
  data() {
    return {
      browsingData: null,
      options: {
        plugins: {
          colorschemes: {
            scheme: 'tableau.ClassicLight10'
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
          text: '過去6時間で見ていたドメインランキング' // ラベル
        }
      }
    }
  },
  async created() {
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
    this.browsingData = {
      labels,
      datasets: [
        {
          data
        }
      ]
    }
  },
  methods: {
    unique(l) {
      return l.filter((x, i, self) => self.indexOf(x) === i)
    },
    labelColors(size) {
      const colors = []
      const templateColor = [
        '#FF4444',
        '#4444FF',
        '#44BB44',
        '#FFFF44',
        '#FF44FF'
      ]
      for (const i in size) {
        colors.push(templateColor[i % templateColor.length])
      }
      return colors
    }
  }
}
</script>
