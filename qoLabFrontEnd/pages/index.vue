<template>
  <v-layout column justify-center align-center>
    <v-flex xs12 sm8 md6>
      <div class="text-xs-center">
        <DomainChart />
        <AppChart />
      </div>
    </v-flex>
  </v-layout>
</template>

<script>
import DomainChart from '@/components/DomainChart'
import AppChart from '@/components/AppChart'

export default {
  middleware: 'auth',
  components: {
    DomainChart,
    AppChart
  }
}
</script>
