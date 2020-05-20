view: seoul_weather_2018 {
  derived_table: {
    sql: select a.sido as sido, a.gungu as gungu, a.dong_split as dong, b.date as date, b.hour as hour, b.temperature as temperature, b.rainfall as rainfall
          from (
            select sw.sido, sw.gungu, sw.dong_split, sw.dong
              from (
                    select a.sido, a.gungu, a.dong_split, a.dong
                          ,case when concat(@sido, @gungu, @dong) = concat(a.sido, a.gungu, a.dong_split) then @RANK:=@RANK + 1 else @RANK :=1 end as RANKING
                          ,@sido := a.sido
                          ,@gungu := a.gungu
                          ,@dong := a.dong_split
                    from (
                      select sido
                         , gungu
                         , (case when left(seoul_weather_2018.dong, 2) regexp '[0-9]'
                                then concat(left(seoul_weather_2018.dong, 1), '동')
                              else left(seoul_weather_2018.dong, 2)
                           end) as dong_split
                         , dong
                         , count(*)
                      from seoul_weather_2018
                      group by sido
                         , gungu
                         , (case when left(seoul_weather_2018.dong, 2) regexp '[0-9]'
                                then concat(left(seoul_weather_2018.dong, 1), '동')
                              else left(seoul_weather_2018.dong, 2)
                           end)
                         , dong
                    ) a , (SELECT @sido := '', @gungu := '', @dong := '', @RANK := 0) XX
              order by 1, 2, 3, 4
              ) sw
              where sw.ranking = 1) a
            , seoul_weather_2018 b
          where a.sido = b.sido
            and a.gungu = b.gungu
            and a.dong = b.dong;;
  }


  dimension: date {
    type: string
    sql: ${TABLE}.date ;;
  }

  dimension: dong {
    type: string
    sql: ${TABLE}.dong ;;
  }

  dimension: gungu {
    type: string
    sql: ${TABLE}.gungu ;;
  }

  dimension: hour {
    type: string
    sql: ${TABLE}.hour ;;
  }

  dimension: rainfall {
    type: number
    sql: ${TABLE}.rainfall ;;
  }

  dimension: sido {
    type: string
    sql: ${TABLE}.sido ;;
  }

  dimension: temperature {
    type: number
    sql: ${TABLE}.temperature ;;
  }

  dimension: rainfall_range {
    case: {
      when: {
        sql: ${TABLE}.rainfall <= 0.0 ;;
        label: "날씨맑음"
      }
      when: {
        sql: ${TABLE}.rainfall < 1.0 ;;
        label: "추적추적 내림"
      }
      when: {
        sql: ${TABLE}.rainfall >= 1.0 AND ${TABLE}.rainfall < 2.0;;
        label: "많이 내림"
      }
      when: {
        sql: ${TABLE}.rainfall >= 2.0 AND ${TABLE}.rainfall < 3.0;;
        label: "억수로 내림"
      }
      when: {
        sql: ${TABLE}.rainfall >= 3.0 AND ${TABLE}.rainfall < 5.0;;
        label: "물통을 뒤집은 것처럼 내림"
      }
      when: {
        sql: ${TABLE}.rainfall >= 5.0 AND ${TABLE}.rainfall < 8.0;;
        label: "폭포와 같이 내림"
      }
      else: "공포"
    }
  }

  dimension: temperature_tier {
    type: tier
    tiers: [-20, -10, 0, 10, 20, 30, 40]
    style:  integer
    sql: ${TABLE}.temperature ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
  measure: temperature_avg {
    type: average
    sql: ${TABLE}.temperature ;;
    drill_fields: [sido, gungu, sido, date, hour]
  }

  measure: rainfall_avg {
    type: average
    sql: ${TABLE}.rainfall ;;
    drill_fields: [sido, gungu, sido, date, hour]
  }
}
