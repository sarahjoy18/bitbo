<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class TIssuance
 * 
 * @property int $ISSUANCE_ID
 * @property int $ISSUANCE_TYPE_ID
 * @property int $RESIDENT_ID
 * @property int $BUSINESS_ID
 * @property string $ISSUANCE_PURPOSE
 * @property \Carbon\Carbon $ISSUANCE_DATE
 * @property string $ISSUANCE_NUMBER
 * @property \Carbon\Carbon $TIME_RECEIVED
 * @property string $RECEIVED_BY
 * @property string $STATUS
 * @property string $REMARKS
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \App\Models\TBusinessInformation $t_business_information
 * @property \App\Models\TResidentBasicInfo $t_resident_basic_info
 * @property \App\Models\RIssuanceCategory $r_issuance_category
 * @property \Illuminate\Database\Eloquent\Collection $t_bf_barangay_certifications
 * @property \Illuminate\Database\Eloquent\Collection $t_bf_barangay_clearances
 * @property \Illuminate\Database\Eloquent\Collection $t_bf_business_activities
 * @property \Illuminate\Database\Eloquent\Collection $t_bf_business_permits
 * @property \Illuminate\Database\Eloquent\Collection $t_bf_certified_records
 * @property \Illuminate\Database\Eloquent\Collection $t_bf_transient_records
 * @property \Illuminate\Database\Eloquent\Collection $t_bf_use_of_facility_equipments
 *
 * @package App\Models
 */
class TIssuance extends Eloquent
{
	protected $table = 't_issuance';
	protected $primaryKey = 'ISSUANCE_ID';
	public $timestamps = false;

	protected $casts = [
		'ISSUANCE_TYPE_ID' => 'int',
		'RESIDENT_ID' => 'int',
		'BUSINESS_ID' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'ISSUANCE_DATE',
		'TIME_RECEIVED',
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'ISSUANCE_TYPE_ID',
		'RESIDENT_ID',
		'BUSINESS_ID',
		'ISSUANCE_PURPOSE',
		'ISSUANCE_DATE',
		'ISSUANCE_NUMBER',
		'TIME_RECEIVED',
		'RECEIVED_BY',
		'STATUS',
		'REMARKS',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function t_business_information()
	{
		return $this->belongsTo(\App\Models\TBusinessInformation::class, 'BUSINESS_ID');
	}

	public function t_resident_basic_info()
	{
		return $this->belongsTo(\App\Models\TResidentBasicInfo::class, 'RESIDENT_ID');
	}

	public function r_issuance_category()
	{
		return $this->belongsTo(\App\Models\RIssuanceCategory::class, 'ISSUANCE_TYPE_ID');
	}

	public function t_bf_barangay_certifications()
	{
		return $this->hasMany(\App\Models\TBfBarangayCertification::class, 'ISSUANCE_ID');
	}

	public function t_bf_barangay_clearances()
	{
		return $this->hasMany(\App\Models\TBfBarangayClearance::class, 'ISSUANCE_ID');
	}

	public function t_bf_business_activities()
	{
		return $this->hasMany(\App\Models\TBfBusinessActivity::class, 'ISSUANCE_ID');
	}

	public function t_bf_business_permits()
	{
		return $this->hasMany(\App\Models\TBfBusinessPermit::class, 'ISSUANCE_ID');
	}

	public function t_bf_certified_records()
	{
		return $this->hasMany(\App\Models\TBfCertifiedRecord::class, 'ISSUANCE_ID');
	}

	public function t_bf_transient_records()
	{
		return $this->hasMany(\App\Models\TBfTransientRecord::class, 'ISSUANCE_ID');
	}

	public function t_bf_use_of_facility_equipments()
	{
		return $this->hasMany(\App\Models\TBfUseOfFacilityEquipment::class, 'ISSUANCE_ID');
	}
}
