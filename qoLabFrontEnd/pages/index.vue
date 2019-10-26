<template>
  <v-layout column justify-center align-center>
    <v-flex xs12 sm8 md6>
      <div class="text-xs-center">
        <DomainChart />
        <KeyChart />
      </div>
    </v-flex>
  </v-layout>
</template>

<script>
import DomainChart from '@/components/DomainChart'
import KeyChart from '@/components/KeyChart'

export default {
  middleware: 'auth',
  components: {
    DomainChart,
    KeyChart
  }
}
</script>
