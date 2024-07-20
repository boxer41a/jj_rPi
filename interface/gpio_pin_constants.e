note
	description: "[
		Constants representing GPIO pins and modes.
		]"
	author: "Jimmy J Johnson"
	date: "10/11/20"

class
	GPIO_PIN_CONSTANTS

feature -- Access

	max_gpio_pin_count: NATURAL_32 = 58

feature -- Pin voltage

	Low: NATURAL_32 = 0
	High: NATURAL_32 = 1

feature -- Pin pull-up/pull-down states

	Pull_none: NATURAL_32 = 0b00
	Pull_up: NATURAL_32 = 0b01
	Pull_down: NATURAL_32 = 0b10

feature -- Pin modes

	input: NATURAL_32 = 0b000
	output: NATURAL_32 = 0b001
	alt0: NATURAL_32 = 0b100
	alt1: NATURAL_32 = 0b101
	alt2: NATURAL_32 = 0b110
	alt3: NATURAL_32 = 0b111
	alt4: NATURAL_32 = 0b011
	alt5: NATURAL_32 = 0b010

feature -- Pin alternate functions (for Pi-4 BCM2711)

-- fix me for other type {PI_CONTROLLER}  New class?

	function_first: INTEGER_32 = 999
			-- Convenience function to get first function constant

	alt_in: INTEGER_32 = 999
		-- A hack so pin mode `input' can be indexed in hash table

	alt_out: INTEGER_32 = 1000		-- matched with output
		-- A hack so pin mode `output' can be indexed in hash table

	arm_rtck: INTEGER_32 = 1001
	arm_tck: INTEGER_32 = 1002
	arm_tdi: INTEGER_32 = 1003
	arm_tdo: INTEGER_32 = 1004
	arm_tms: INTEGER_32 = 1005
	arm_trst: INTEGER_32 = 1006
	bscsl_ce_n: INTEGER_32 = 1007
	bscsl_miso: INTEGER_32 = 1008
	bscsl_scl_sclk: INTEGER_32 = 1009		-- "BSCSL SCL / SCLK"  ?
	bscsl_sda_mosi: INTEGER_32 = 1010		-- "BSCSL SDA / MOSI"  ?
	cts0: INTEGER_32 = 1011
	cts1: INTEGER_32 = 1012
	cts2: INTEGER_32 = 1013
	cts3: INTEGER_32 = 1014
	cts4: INTEGER_32 = 1015
	cts5: INTEGER_32 = 1016
	de: INTEGER_32 = 1017
	dpi_d0: INTEGER_32 = 1018
	dpi_d1: INTEGER_32 = 1019
	dpi_d2: INTEGER_32 = 1020
	dpi_d3: INTEGER_32 = 1021
	dpi_d4: INTEGER_32 = 1022
	dpi_d5: INTEGER_32 = 1023
	dpi_d6: INTEGER_32 = 1024
	dpi_d7: INTEGER_32 = 1025
	dpi_d8: INTEGER_32 = 1026
	dpi_d9: INTEGER_32 = 1027
	dpi_d10: INTEGER_32 = 1028
	dpi_d11: INTEGER_32 = 1029
	dpi_d12: INTEGER_32 = 1030
	dpi_d13: INTEGER_32 = 1031
	dpi_d14: INTEGER_32 = 1032
	dpi_d15: INTEGER_32 = 1033
	dpi_d16: INTEGER_32 = 1034
	dpi_d17: INTEGER_32 = 1035
	dpi_d18: INTEGER_32 = 1036
	dpi_d19: INTEGER_32 = 1037
	dpi_d20: INTEGER_32 = 1038
	dpi_d21: INTEGER_32 = 1039
	dpi_d22: INTEGER_32 = 1040
	dpi_d23: INTEGER_32 = 1041
	gpclk0: INTEGER_32 = 1041
	gpclk1: INTEGER_32 = 1043
	gpclk2: INTEGER_32 = 1044
	lcd_vsync: INTEGER_32 = 1044
	lcd_hsync: INTEGER_32 = 1046
	mii_a_col: INTEGER_32 = 1047
	mii_a_crs: INTEGER_32 = 1048
	mii_a_rx_err: INTEGER_32 = 1049
	mii_a_tx_err: INTEGER_32 = 1050
	pclk: INTEGER_32 = 1051
	pcm_clk: INTEGER_32 = 1052
	pcm_din: INTEGER_32 = 1053
	pcm_dout: INTEGER_32 = 1054
	pcm_fs: INTEGER_32 = 1055
	pwm0_0: INTEGER_32 = 1056
	pwm0_1: INTEGER_32 = 1057
	pwm1_0: INTEGER_32 = 1058
	pwm1_1: INTEGER_32 = 1059
	rgmii_irq: INTEGER_32 = 1060
	rgmii_mdio: INTEGER_32 = 1061
	rgmii_mdc: INTEGER_32 = 1062
	rgmii_rx_ok: INTEGER_32 = 1063
	rgmii_start_stop: INTEGER_32 = 1064
	rts0: INTEGER_32 = 1065
	rts1: INTEGER_32 = 1066
	rts2: INTEGER_32 = 1067
	rts3: INTEGER_32 = 1068
	rts4: INTEGER_32 = 1069
	rts5: INTEGER_32 = 1070
	rxd0: INTEGER_32 = 1071
	rxd1: INTEGER_32 = 1072
	rxd2: INTEGER_32 = 1073
	rxd3: INTEGER_32 = 1074
	rxd4: INTEGER_32 = 1075
	rxd5: INTEGER_32 = 1076
	sa0: INTEGER_32 = 1077
	sa1: INTEGER_32 = 1078
	sa2: INTEGER_32 = 1079
	sa3: INTEGER_32 = 1080
	sa4: INTEGER_32 = 1081
	sa5: INTEGER_32 = 1082
	scl0: INTEGER_32 = 1083
	scl1: INTEGER_32 = 1084
	scl3: INTEGER_32 = 1085
	scl4: INTEGER_32 = 1086
	scl5: INTEGER_32 = 1087
	scl6: INTEGER_32 = 1088
	sd0: INTEGER_32 = 1089
	sd1: INTEGER_32 = 1090
	sd2: INTEGER_32 = 1091
	sd3: INTEGER_32 = 1092
	sd4: INTEGER_32 = 1093
	sd5: INTEGER_32 = 1094
	sd6: INTEGER_32 = 1095
	sd7: INTEGER_32 = 1096
	sd8: INTEGER_32 = 1097
	sd9: INTEGER_32 = 1098
	sd10: INTEGER_32 = 1099
	sd11: INTEGER_32 = 1100
	sd12: INTEGER_32 = 1101
	sd13: INTEGER_32 = 1102
	sd14: INTEGER_32 = 1102
	sd15: INTEGER_32 = 1104
	sd16: INTEGER_32 = 1105
	sd17: INTEGER_32 = 1106
	sd0_clk: INTEGER_32 = 1107
	sd0_cmd: INTEGER_32 = 1108
	sd0_dat0: INTEGER_32 = 1109
	sd0_dat1: INTEGER_32 = 1110
	sd0_dat2: INTEGER_32 = 1111
	sd0_dat3: INTEGER_32 = 1112
	sd1_clk: INTEGER_32 = 1113
	sd1_cmd: INTEGER_32 = 1114
	sd1_dat0: INTEGER_32 = 1115
	sd1_dat1: INTEGER_32 = 1116
	sd1_dat2: INTEGER_32 = 1117
	sd1_dat3: INTEGER_32 = 1118
	sd1_dat4: INTEGER_32 = 1119
	sd1_dat5: INTEGER_32 = 1120
	sd1_dat6: INTEGER_32 = 1121
	sd1_dat7: INTEGER_32 = 1122
	sda0: INTEGER_32 = 1123
	sda1: INTEGER_32 = 1124
	sda3: INTEGER_32 = 1125
	sda4: INTEGER_32 = 1126
	sda5: INTEGER_32 = 1127
	sda6: INTEGER_32 = 1128
	sd_card_led: INTEGER_32 = 1129
	sd_card_vold: INTEGER_32 = 1130
	sd_card_pres: INTEGER_32 = 1131
	sd_card_pwr0: INTEGER_32 = 1132
	sd_card_wrprot: INTEGER_32 = 1133
	soe_n_se: INTEGER_32 = 1134			-- "SOE_N / SE"  ?
	spi0_ce0_n: INTEGER_32 = 1135
	spi0_ce1_n: INTEGER_32 = 1136
	spi0_ce2_n: INTEGER_32 = 1137
	spi0_miso: INTEGER_32 = 1138
	spi0_mosi: INTEGER_32 = 1139
	spi0_sclk: INTEGER_32 = 1140
	spi1_ce0_n: INTEGER_32 = 1149
	spi1_ce1_n: INTEGER_32 = 1142
	spi1_ce2_n: INTEGER_32 = 1142
	spi1_miso: INTEGER_32 = 1144
	spi1_mosi: INTEGER_32 = 1145
	spi1_sclk: INTEGER_32 = 1146
	spi3_ce0_n: INTEGER_32 = 1147
	spi3_ce1_n: INTEGER_32 = 1148
	spi3_miso: INTEGER_32 = 1149
	spi3_mosi: INTEGER_32 = 1150
	spi3_sclk: INTEGER_32 = 1151
	spi4_ce0_n: INTEGER_32 = 1152
	spi4_ce1_n: INTEGER_32 = 1153
	spi4_miso: INTEGER_32= 1154
	spi4_mosi: INTEGER_32 = 1155
	spi4_sclk: INTEGER_32 = 1056
	spi5_ce0_n: INTEGER_32 = 1157
	spi5_ce1_n: INTEGER_32 = 1158
	spi5_miso: INTEGER_32 = 1159
	spi5_mosi: INTEGER_32 = 1160
	spi5_sclk: INTEGER_32 = 1161
	spi6_ce0_n: INTEGER_32 = 1162
	spi6_ce1_n: INTEGER_32 = 1163
	spi6_miso: INTEGER_32 = 1164
	spi6_moso: INTEGER_32 = 1165
	spi6_sclk: INTEGER_32 = 1166
	swe_n_srw_n: INTEGER_32 = 1167		-- "SWE_N / SRW_N"  ?
	txd0: INTEGER_32 = 1168
	txd1: INTEGER_32 = 1169
	txd2: INTEGER_32 = 1170
	txd3: INTEGER_32 = 1171
	txd4: INTEGER_32 = 1172
	txd5: INTEGER_32 = 1173

	function_last: INTEGER_32 = 1173
			-- Convenience function to get last function constant

end
