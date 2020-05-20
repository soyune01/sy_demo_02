connection: "hyper_looker"

# include all the views
include: "/views/**/*.view"

datagroup: hyper_looker_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: call_delivery_datagroup {
  #sql_trigger: select count(*) from call_delivery;;
  max_cache_age: "5 minutes"
}

persist_with: hyper_looker_default_datagroup

explore: call_delivery {
  persist_with: call_delivery_datagroup
  join: seoul_weather_2018 {
    type: inner
    sql_on: ${call_delivery.addr_sido} = ${seoul_weather_2018.sido}
              AND ${call_delivery.addr_sigungu} = ${seoul_weather_2018.gungu}
              AND left(${call_delivery.addr_dong}, 2) = ${seoul_weather_2018.dong}
              AND ${call_delivery.date} = ${seoul_weather_2018.date}
              AND ${call_delivery.time_tier} = ${seoul_weather_2018.hour};;
    relationship: one_to_one
  }
}

explore: seoul_population {}

explore: seoul_weather_2018 {}
