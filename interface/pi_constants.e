note
	description: "[
	Constants used by Raspberry Pi 4B, such as base memory 
	address, etc.
	]"
	author: "Jimmy J. Johnson"
	date: "9/25/20"

class
	PI_CONSTANTS

feature -- Access

	Unknown: NATURAL_32 = 9999

feature -- Access (Pi memory size)

	Memory_256mb: NATURAL_32 = 201
	Memory_512mb: NATURAL_32 = 202
	Memory_1gb: NATURAL_32 = 203
	Memory_2gb: NATURAL_32 = 204
	Memory_4gb: NATURAL_32 = 205
	Memory_8gb: NATURAL_32 = 206

feature -- Access (manufacturer)

	Manufacturer_sony_uk: NATURAL_32 = 301
	Manufacturer_egoman: NATURAL_32 = 302
	Manufacturer_embest: NATURAL_32 = 303
	Manufacturer_sony_japan: NATURAL_32 = 304
--	Manufacturer_embest: NATURAL_32 = 305
	Manufacturer_stadium: NATURAL_32 = 306

feature -- Access (processor)

	Processor_bcm2835: NATURAL_32 = 401
	Processor_bcm2836: NATURAL_32 = 402
	Processor_bcm2837: NATURAL_32 = 403
	Processor_bcm2711: NATURAL_32 = 404

feature -- Access (Pi model type)

	Model_a: NATURAL_32 = 101
	Model_b: NATURAL_32 = 102
	Model_a_plus: NATURAL_32 = 103
	Model_b_plus: NATURAL_32 = 104
	Model_2b: NATURAL_32 = 105
	Model_Alpha: NATURAL_32 = 106
	Model_cm1: NATURAL_32 = 107
	Model_3b: NATURAL_32 = 108
	Model_zero: NATURAL_32 = 109
	Model_cm3: NATURAL_32 = 110
	Model_zero_w: NATURAL_32 = 111
	Model_3b_plus: NATURAL_32 = 112
	Model_3a_plus: NATURAL_32 = 113
	Model_cm3_plus: NATURAL_32 = 114
	Model_4b: NATURAL_32 = 115
	Model_4b_plus: NATURAL_32 = 116

feature -- Querry

	constant_as_string (a_constant: NATURAL_32): STRING
			-- String describing `a_contant'
		do
			inspect a_constant
			when Unknown then  Result := "Unknown"
				-- Memory size
			when Memory_256mb then  Result := "256MB"
			when Memory_512mb then  Result := "512MB"
			when Memory_1gb then    Result := "1GB"
			when Memory_2gb then    Result := "2GB"
			when Memory_4gb then    Result := "4GB"
			when Memory_8gb then    Result := "8GB"
				-- Manufacturer
			when Manufacturer_sony_uk then  Result := "Sony UK"
			when Manufacturer_egoman then  Result := "Egoman"
			when Manufacturer_embest then  Result := "Embest"
			when Manufacturer_sony_japan then  Result := "Sony Japan"
			when Manufacturer_stadium then  Result := "Stadium"
				-- Processor
			when Processor_bcm2835 then  Result := "BCM2835"
			when Processor_bcm2836 then  Result := "BCM2836"
			when Processor_bcm2837 then  Result := "BCM2837"
			when Processor_bcm2711 then  Result := "BCM2711"
				-- Model type
			when Model_a then  Result := "A"
			when Model_b then  Result := "B"
			when Model_a_plus then  Result := "A+"
			when Model_b_plus then  Result := "B+"
			when Model_2b then  Result := "2B"
			when Model_alpha then  Result := "Alpha"
			when Model_cm1 then  Result := "CM1"
			when Model_3b then  Result := "3b"
			when Model_zero then  Result := "Zero"
			when Model_cm3 then  Result := "CM3"
			when Model_zero_w then  Result := "Zero W"
			when Model_3b_plus then  Result := "3B+"
			when Model_3a_plus then  Result := "3A+"
			when Model_cm3_plus then  Result := "CM3+"
			when Model_4b then  Result := "4B"
			when Model_4b_plus then  Result := "4B+"
			else
				Result := a_constant.out
			end
		end

feature {NONE} -- Implementation


end

