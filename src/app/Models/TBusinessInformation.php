<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class TBusinessInformation
 * 
 * @property int $BUSINESS_ID
 * @property string $BUSINESS_NAME
 * @property string $TRADE_NAME
 * @property int $BUSINESS_NATURE_ID
 * @property string $BUSINESS_OWNER
 * @property string $BUSINESS_ADDRESS
 * @property string $BUSINESS_OR_NUMBER
 * @property \Carbon\Carbon $BUSINESS_OR_ACQUIRED_DATE
 * @property int $BARANGAY_ZONE_ID
 * @property string $TIN_NO
 * @property string $DTI_REGISTRATION_NO
 * @property string $TYPE_OF_BUSINESS
 * @property string $BUSINESS_POSTAL_CODE
 * @property string $BUSINESS_EMAIL_ADD
 * @property string $BUSINESS_TELEPHONE_NO
 * @property string $BUSINESS_MOBILE_NO
 * @property string $OWNER_ADDRESS
 * @property string $OWNER_POSTAL_CODE
 * @property string $OWNER_EMAIL_ADD
 * @property string $OWNER_TELEPHONE_NO
 * @property string $OWNER_MOBILE_NO
 * @property string $EMERGENCY_CONTACT_PERSON
 * @property string $EMERGENCY_PERSON_CONTACT_NO
 * @property string $EMERGENCY_PERSON_EMAIL_ADD
 * @property string $BUSINESS_AREA
 * @property int $NO_EMPLOYEE_ESTABLISHMENT
 * @property int $NO_EMPLOYEE_LGU
 * @property string $LESSOR_NAME
 * @property string $LESSOR_ADDRESS
 * @property string $LESSOR_CONTACT_NO
 * @property string $LESSOR_EMAIL_ADD
 * @property string $MONTHLY_RENTAL
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \App\Models\RBusinessNature $r_business_nature
 * @property \App\Models\RBarangayZone $r_barangay_zone
 * @property \Illuminate\Database\Eloquent\Collection $t_issuances
 *
 * @package App\Models
 */
class TBusinessInformation extends Eloquent
{
	protected $table = 't_business_information';
	protected $primaryKey = 'BUSINESS_ID';
	public $timestamps = false;

	protected $casts = [
		'BUSINESS_NATURE_ID' => 'int',
		'BARANGAY_ZONE_ID' => 'int',
		'NO_EMPLOYEE_ESTABLISHMENT' => 'int',
		'NO_EMPLOYEE_LGU' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'BUSINESS_OR_ACQUIRED_DATE',
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'BUSINESS_NAME',
		'TRADE_NAME',
		'BUSINESS_NATURE_ID',
		'BUSINESS_OWNER',
		'BUSINESS_ADDRESS',
		'BUSINESS_OR_NUMBER',
		'BUSINESS_OR_ACQUIRED_DATE',
		'BARANGAY_ZONE_ID',
		'TIN_NO',
		'DTI_REGISTRATION_NO',
		'TYPE_OF_BUSINESS',
		'BUSINESS_POSTAL_CODE',
		'BUSINESS_EMAIL_ADD',
		'BUSINESS_TELEPHONE_NO',
		'BUSINESS_MOBILE_NO',
		'OWNER_ADDRESS',
		'OWNER_POSTAL_CODE',
		'OWNER_EMAIL_ADD',
		'OWNER_TELEPHONE_NO',
		'OWNER_MOBILE_NO',
		'EMERGENCY_CONTACT_PERSON',
		'EMERGENCY_PERSON_CONTACT_NO',
		'EMERGENCY_PERSON_EMAIL_ADD',
		'BUSINESS_AREA',
		'NO_EMPLOYEE_ESTABLISHMENT',
		'NO_EMPLOYEE_LGU',
		'LESSOR_NAME',
		'LESSOR_ADDRESS',
		'LESSOR_CONTACT_NO',
		'LESSOR_EMAIL_ADD',
		'MONTHLY_RENTAL',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function r_business_nature()
	{
		return $this->belongsTo(\App\Models\RBusinessNature::class, 'BUSINESS_NATURE_ID');
	}

	public function r_barangay_zone()
	{
		return $this->belongsTo(\App\Models\RBarangayZone::class, 'BARANGAY_ZONE_ID');
	}

	public function t_issuances()
	{
		return $this->hasMany(\App\Models\TIssuance::class, 'BUSINESS_ID');
	}
}
