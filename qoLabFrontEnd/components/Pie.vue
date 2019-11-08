<script>
import { Pie, mixins } from 'vue-chartjs'
import 'chartjs-plugin-colorschemes'
const { reactiveProp } = mixins

export default {
  extends: Pie,
  mixins: [reactiveProp],
  props: {
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
  mounted() {
    // this.chartData is created in the mixin.
    // If you want to pass options please create a local options object
    this.renderChart(this.chartData, this.options)
  }
}
</script>
