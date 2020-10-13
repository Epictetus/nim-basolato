import unittest, json, tables
import ../src/basolato/request_validation
import allographer/query_builder
import allographer/schema_builder


suite "validation":
  test "accepted":
    var params = {"key": "on"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.accepted("key")
    check v.errors.len == 0

    params = {"key": "checked"}.toTable()
    v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.accepted("key", "checked")
    check v.errors.len == 0

  test "accepted invalid":
    var params = {"key": ""}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.accepted("key")
    check v.errors.len > 0

  # ==========================================================================
  test "contains":
    var params = {"key": "111user222"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.contains("key", "user")
    check v.errors.len == 0

  test "contains invalid":
    var params = {"key": "111user222"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.contains("key", "owner")
    check v.errors.len > 0

  # ==========================================================================
  test "digits":
    var params = {"key": "111"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.digits("key", 3)
    check v.errors.len == 0

  test "digits invalid":
    var params = {"key": "111"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.digits("key", 2)
    check v.errors.len > 0

  # ==========================================================================
  test "email":
    let valid_addresses = [
      {"email": "user@example.com"}.toTable(),
      {"email": "USER@foo.COM"}.toTable(),
      {"email": "A_US-ER@foo.bar.org"}.toTable(),
      {"email": "first.last@foo.jp"}.toTable(),
      {"email": "alice+bob@baz.cn"}.toTable()
    ]

    for valid_address in valid_addresses:
      var v = RequestValidation(
        params: valid_address,
        errors: newJObject()
      )
      v.email("email")
      check v.errors.len == 0

  test "email invalid":
    let valid_addresses = [
      {"email": "asdadad"}.toTable(),
      {"email": "adaasda@asdaa"}.toTable(),
      {"email": ";/@;@;:"}.toTable(),
      {"email": "foo@bar..com"}.toTable(),
      {"email": ""}.toTable()
    ]

    for valid_address in valid_addresses:
      var v = RequestValidation(
        params: valid_address,
        errors: newJObject()
      )
      v.email("email")
      check v.errors.len > 0

  # ==========================================================================
  test "equals":
    var params = {"key": "John"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.equals("key", "John")
    check v.errors.len == 0

  test "equals invalid":
    var params = {"key": "John"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject())
    v.equals("key", "Paul")
    check v.errors.len > 0

  # ==========================================================================
  test "exists":
    var params = {"name": "John", "age": "10"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.exists("name")
    check v.errors.len == 0

  test "exists invalid":
    var params = {"age": "10"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject())
    v.exists("name")
    check v.errors.len > 0

  # ==========================================================================
  test "gratorThan":
    var params = {"age": "10"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject())
    v.gratorThan("age", 9)
    check v.errors.len == 0

  test "gratorThan invalid":
    var params = {"age": "10"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.gratorThan("age", 11)
    check v.errors.len > 0

  # ==========================================================================
  test "inRange":
    var params = {"age": "10"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.inRange("age", min=9, max=11)
    check v.errors.len == 0

  test "inRange invalid":
    var params = {"age": "10"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.inRange("age", min=11, max=15)
    check v.errors.len > 0

  # ==========================================================================
  test "ip":
    var params = [
      {"ip_address": "127.0.0.1"}.toTable(),
      {"ip_address": "192.168.0.80"}.toTable(),
      {"ip_address": "123.123.123.123"}.toTable(),
      {"ip_address": "255.255.255.255"}.toTable(),
      {"ip_address": "001.002.003.004"}.toTable(),
      {"ip_address": "2001:0db8:bd05:01d2:288a:1fc0:0001:10ee"}.toTable(),
      {"ip_address": "2001:db8:20:3:1000:100:20:3"}.toTable(),
      {"ip_address": "2001:db8::1234:0:0:9abc"}.toTable(),
      {"ip_address": "2001:db8::9abc"}.toTable(),
      {"ip_address": "::1"}.toTable(),
      {"ip_address": "::ffff:255.255.255.255"}.toTable(),
    ]
    for param in params:
      var v = RequestValidation(
        params: param,
        errors: newJObject()
      )
      v.ip("ip_address")
      check v.errors.len == 0

  test "ip invalid":
    var params = [
      {"ip_address": "dsdsadads"}.toTable(),
      {"ip_address": "127.0.0.1111"}.toTable(),
      {"ip_address": "example.com:hoge"}.toTable(),
      {"ip_address": "fuga:xxxxxxx"}.toTable(),
      {"ip_address": "2001:0db8:bd05:01d2:288a::1fc0:0001:10ee"}.toTable(),
      {"ip_address": "2001:0db8:bd05:01d2:288a:1fc0:0001:10ee:11fe"}.toTable(),
      {"ip_address": "::"}.toTable(),
      {"ip_address": "1::"}.toTable(),
      {"ip_address": "1:2:3:4:5:6:7::"}.toTable(),
      {"ip_address": "::255.255.255.255"}.toTable(),
      {"ip_address": "2001:db8:3:4::192.0.2.33"}.toTable(),
      {"ip_address": "64:ff9b::192.0.2.33"}.toTable(),
      {"ip_address": "0.0.0.0"}.toTable(),
      {"ip_address": "1111.1111.1111.11111"}.toTable(),
    ]
    for param in params:
      var v = RequestValidation(
        params: param,
        errors: newJObject()
      )
      v.ip("ip_address")
      check v.errors.len > 0

  # ==========================================================================
  test "isBool":
    var params = {"key": "true"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.isBool("key")
    check v.errors.len == 0

    params = {"key": "false"}.toTable()
    v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.isBool("key")
    check v.errors.len == 0

  test "isBool invalid":
    var params = {"key": "111"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.isBool("key")
    check v.errors.len > 0

  # ==========================================================================
  test "isFloat":
    var params = {"key": "1.1"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.isFloat("key")
    check v.errors.len == 0

  test "isFloat invalid":
    var params = {"key": "a"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.isFloat("key")
    check v.errors.len > 0

  # ==========================================================================
  test "isIn":
    var params = {"name": "John"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.isIn("name", ["John", "Paul", "George", "Ringo"])
    check v.errors.len == 0

  test "isIn invalid":
    var params = {"name": "David"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.isIn("name", ["John", "Paul", "George", "Ringo"])
    check v.errors.len > 0

  # ==========================================================================
  test "isInt":
    var params = {"key": "1"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.isInt("key")
    check v.errors.len == 0

  test "isInt invalid":
    var params = {"key": "a"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.isInt("key")
    check v.errors.len > 0

  # ==========================================================================
  test "isString":
    var params = {"key": "aa"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.isString("key")
    check v.errors.len == 0

  test "isString invalid":
    var params = {"key": "1"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.isString("key")
    check v.errors.len > 0

    params = {"key": "1.1"}.toTable()
    v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.isString("key")
    check v.errors.len > 0

    params = {"key": "true"}.toTable()
    v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.isString("key")
    check v.errors.len > 0

  # ==========================================================================
  test "lessThan":
    var params = {"age": "25"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.gratorThan("age", 24)
    check v.errors.len == 0

  test "lessThan invalid":
    var params = {"age": "25"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.gratorThan("age", 26)
    check v.errors.len > 0

  # ==========================================================================
  test "numeric":
    var params = {"num": "36.2"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.numeric("num")
    check v.errors.len == 0

  test "numeric invalid":
    var params = {"num": "aaaaa"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.numeric("num")
    check v.errors.len > 0

  # ==========================================================================
  test "oneOf":
    var params = {"name": "John", "email": "John@gmail.com"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.oneOf(["name", "birth_date", "job"])
    check v.errors.len == 0

  test "oneOf invalid":
    var params = {"name": "John", "email": "John@gmail.com"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.oneOf(["birth_date", "job"])
    check v.errors.len > 0

  # ==========================================================================
  test "password":
    var params = {"pass": "Password1!"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.password("pass")
    check v.errors.len == 0

  test "password invalid":
    var params = {"pass": "pass12"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.password("pass")
    check v.errors.len > 0

  # ==========================================================================
  test "required":
    var params = {"name": "John", "email": "John@gmail.com"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.required(["name", "email"])
    check v.errors.len == 0

  test "required invalid":
    var params = {"name": "John", "email": "John@gmail.com"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.required(["name", "email", "job"])
    check v.errors.len > 0

  # ==========================================================================
  test "unique":
    schema([
      table("test_users", [
        Column().increments("id"),
        Column().string("name"),
        Column().string("email")
      ], reset=true)
    ])

    RDB().table("test_users").insert([
      %*{
        "name": "user1",
        "email": "user1@gmail.com",
      },
      %*{
        "name": "user2",
        "email": "user2@gmail.com",
      }
    ])

    var params = {"mail": "user3@gmail.com"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.unique("mail", "test_users", "email")
    check v.errors.len == 0

  test "unique invalid":
    var params = {"mail": "user2@gmail.com"}.toTable()
    var v = RequestValidation(
      params: params,
      errors: newJObject()
    )
    v.unique("mail", "test_users", "email")
    check v.errors.len > 0
