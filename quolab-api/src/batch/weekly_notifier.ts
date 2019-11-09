import axios from "axios";
import { isFriday } from "date-fns";
async function main() {
  if (!isFriday(new Date())) {
    return;
  }
  try {
    // const resp = await axios.get('http://localhost:3000/slack-config')

    const resp = await axios.get(
      "https://qolab-api.herokuapp.com/slack-config",
    );
    resp.data.forEach(slackConf => {
      axios.post(slackConf.url, {
        text:
          "今週の活動を振り返ってみよう！\nhttps://qolab-a0324.firebaseapp.com/weekly_reports",
        channel: slackConf.channel,
      });
    });
  } catch (e) {
    console.debug(e);
  }
}
main();
