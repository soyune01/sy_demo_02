view: call_delivery {
  sql_table_name: looker_demo.call_delivery ;;

  dimension: addr_dong {
    type: string
    sql: ${TABLE}.addr_dong;;
  }

  dimension: addr_sido {
    type: string
    sql: ${TABLE}.addr_sido ;;
  }

  dimension: addr_sigungu {
    type: string
    sql: ${TABLE}.addr_sigungu ;;
  }

  dimension: call_cnt {
    type: number
    sql: ${TABLE}.call_cnt ;;
  }


  dimension: date {
    type: string
    sql: ${TABLE}.date;;
  }

  dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: day_orderby {
    type: number
    sql: CASE WHEN  ${TABLE}.day = '월' THEN 1
                WHEN  ${TABLE}.day = '화' THEN 2
                WHEN  ${TABLE}.day = '수' THEN 3
                WHEN  ${TABLE}.day = '목' THEN 4
                WHEN  ${TABLE}.day = '금' THEN 5
                WHEN  ${TABLE}.day = '토' THEN 6
                WHEN  ${TABLE}.day = '일' THEN 7
            ELSE 99 END ;;
  }

  dimension: day {
    type: string
    sql: ${TABLE}.day ;;
    order_by_field: day_orderby
  }


  dimension: industry_item {
    type: string
    sql: ${TABLE}.industry_item ;;
    link: {
      label: "Google"
      url: "http://www.google.com/search?q={{ value }}"
      icon_url: "http://google.com/favicon.ico"
    }
  }

  dimension: time_tier {
    type: string
    sql: ${TABLE}.time_tier ;;
  }

  measure: count {
    type: count
    drill_fields: [call_details*]
  }

  measure: call_sum {
    type: sum
    sql: ${TABLE}.call_cnt ;;
    drill_fields: [call_details*]
  }

  measure: call_sum_chicken {
    type:sum
    sql: CASE WHEN  ${TABLE}.industry_item = '치킨' THEN ${TABLE}.call_cnt ELSE 0 END ;;
  }
  measure: call_sum_pizza {
    type: sum
    sql: CASE WHEN  ${TABLE}.industry_item = '피자' THEN ${TABLE}.call_cnt ELSE 0 END ;;
  }
  measure: call_sum_china {
    type: sum
    sql: CASE WHEN  ${TABLE}.industry_item = '음식점-중국음식' THEN ${TABLE}.call_cnt ELSE 0 END ;;
  }
  measure: call_sum_pork {
    type: sum
    sql: CASE WHEN  ${TABLE}.industry_item = '음식점-족발/보쌈전문' THEN ${TABLE}.call_cnt ELSE 0 END ;;
  }

  set: call_details {
    fields: [addr_sido, addr_sigungu, addr_dong, date, time_tier, industry_item,call_cnt]
  }
}
