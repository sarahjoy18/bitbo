<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class TBfUseOfFacilityEquipment
 * 
 * @property int $USE_OF_FACILITY_EQUIPMENT_ID
 * @property string $ORGANIZATION_NAME
 * @property string $AUTHORIZED_REPRESENTATIVE
 * @property string $REPRESENTATIVE_ADDRESS
 * @property string $REPRESENTATIVE_CONTACT_NO
 * @property string $REPRESENTATIVE_EMAIL
 * @property string $PERSON_PRESENT_AT_EVENT
 * @property string $PERSON_ADDRESS
 * @property string $PERSON_CONTACT_NO
 * @property string $PERSON_EMAIL
 * @property string $ACTIVITY
 * @property string $PURPOSE
 * @property \Carbon\Carbon $DATE_NEEDED
 * @property \Carbon\Carbon $TIME_NEEDED
 * @property string $PARTICIPANTS
 * @property string $HOURS_OF_USE
 * @property int $HAVE_ADMISSION_FEE
 * @property string $VENUE
 * @property int $IS_SECURITY_REQUIRED
 * @property int $NO_OF_SECURITY
 * @property \Carbon\Carbon $DATE_SECURITY
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * @property int $ISSUANCE_ID
 * 
 * @property \App\Models\TIssuance $t_issuance
 * @property \Illuminate\Database\Eloquent\Collection $t_bf_uof_facility_equipments
 *
 * @package App\Models
 */
class TBfUseOfFacilityEquipment extends Eloquent
{
	protected $table = 't_bf_use_of_facility_equipment';
	protected $primaryKey = 'USE_OF_FACILITY_EQUIPMENT_ID';
	public $timestamps = false;

	protected $casts = [
		'HAVE_ADMISSION_FEE' => 'int',
		'IS_SECURITY_REQUIRED' => 'int',
		'NO_OF_SECURITY' => 'int',
		'ACTIVE_FLAG' => 'int',
		'ISSUANCE_ID' => 'int'
	];

	protected $dates = [
		'DATE_NEEDED',
		'TIME_NEEDED',
		'DATE_SECURITY',
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'ORGANIZATION_NAME',
		'AUTHORIZED_REPRESENTATIVE',
		'REPRESENTATIVE_ADDRESS',
		'REPRESENTATIVE_CONTACT_NO',
		'REPRESENTATIVE_EMAIL',
		'PERSON_PRESENT_AT_EVENT',
		'PERSON_ADDRESS',
		'PERSON_CONTACT_NO',
		'PERSON_EMAIL',
		'ACTIVITY',
		'PURPOSE',
		'DATE_NEEDED',
		'TIME_NEEDED',
		'PARTICIPANTS',
		'HOURS_OF_USE',
		'HAVE_ADMISSION_FEE',
		'VENUE',
		'IS_SECURITY_REQUIRED',
		'NO_OF_SECURITY',
		'DATE_SECURITY',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG',
		'ISSUANCE_ID'
	];

	public function t_issuance()
	{
		return $this->belongsTo(\App\Models\TIssuance::class, 'ISSUANCE_ID');
	}

	public function t_bf_uof_facility_equipments()
	{
		return $this->hasMany(\App\Models\TBfUofFacilityEquipment::class, 'USE_OF_FACILITY_EQUIPMENT_ID');
	}
}
