<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class TResidentBasicInfo
 * 
 * @property int $RESIDENT_ID
 * @property int $HOUSEHOLD_ID
 * @property string $LASTNAME
 * @property string $MIDDLENAME
 * @property string $FIRSTNAME
 * @property string $ADDRESS_UNIT_NO
 * @property string $ADDRESS_PHASE
 * @property string $ADDRESS_BLOCK_NO
 * @property string $ADDRESS_HOUSE_NO
 * @property string $ADDRESS_STREET
 * @property string $ADDRESS_SUBDIVISION
 * @property string $ADDRESS_BUILDING
 * @property string $QUALIFIER
 * @property \Carbon\Carbon $DATE_OF_BIRTH
 * @property string $PLACE_OF_BIRTH
 * @property string $SEX
 * @property string $CIVIL_STATUS
 * @property int $IS_OFW
 * @property string $OCCUPATION
 * @property string $WORK_STATUS
 * @property \Carbon\Carbon $DATE_STARTED_WORKING
 * @property string $CITIZENSHIP
 * @property string $RELATION_TO_HOUSEHOLD_HEAD
 * @property \Carbon\Carbon $DATE_OF_ARRIVAL
 * @property string $ARRIVAL_STATUS
 * @property int $IS_INDIGENOUS
 * @property string $CONTACT_NUMBER
 * @property string $TIN_NO
 * @property string $SSS_NO
 * @property int $GSIS_NO
 * @property string $EMAIL_ADDRESS
 * @property string $EDUCATIONAL_ATTAINMENT
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \App\Models\THouseholdInformation $t_household_information
 * @property \Illuminate\Database\Eloquent\Collection $t_barangay_officials
 * @property \Illuminate\Database\Eloquent\Collection $t_blotters
 * @property \Illuminate\Database\Eloquent\Collection $t_childen_profiles
 * @property \Illuminate\Database\Eloquent\Collection $t_fathers_profiles
 * @property \Illuminate\Database\Eloquent\Collection $t_hs_adolescents
 * @property \Illuminate\Database\Eloquent\Collection $t_hs_chronic_coughs
 * @property \Illuminate\Database\Eloquent\Collection $t_hs_chronic_diseases
 * @property \Illuminate\Database\Eloquent\Collection $t_hs_family_plannings
 * @property \Illuminate\Database\Eloquent\Collection $t_hs_newborns
 * @property \Illuminate\Database\Eloquent\Collection $t_hs_non_family_planning_users
 * @property \Illuminate\Database\Eloquent\Collection $t_hs_pregnants
 * @property \Illuminate\Database\Eloquent\Collection $t_hs_pwds
 * @property \Illuminate\Database\Eloquent\Collection $t_issuances
 * @property \Illuminate\Database\Eloquent\Collection $t_mothers_profiles
 *
 * @package App\Models
 */
class TResidentBasicInfo extends Eloquent
{
	protected $table = 't_resident_basic_info';
	protected $primaryKey = 'RESIDENT_ID';
	public $timestamps = false;

	protected $casts = [
		'HOUSEHOLD_ID' => 'int',
		'IS_OFW' => 'int',
		'IS_INDIGENOUS' => 'int',
		'GSIS_NO' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'DATE_OF_BIRTH',
		'DATE_STARTED_WORKING',
		'DATE_OF_ARRIVAL',
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'HOUSEHOLD_ID',
		'LASTNAME',
		'MIDDLENAME',
		'FIRSTNAME',
		'ADDRESS_UNIT_NO',
		'ADDRESS_PHASE',
		'ADDRESS_BLOCK_NO',
		'ADDRESS_HOUSE_NO',
		'ADDRESS_STREET',
		'ADDRESS_SUBDIVISION',
		'ADDRESS_BUILDING',
		'QUALIFIER',
		'DATE_OF_BIRTH',
		'PLACE_OF_BIRTH',
		'SEX',
		'CIVIL_STATUS',
		'IS_OFW',
		'OCCUPATION',
		'WORK_STATUS',
		'DATE_STARTED_WORKING',
		'CITIZENSHIP',
		'RELATION_TO_HOUSEHOLD_HEAD',
		'DATE_OF_ARRIVAL',
		'ARRIVAL_STATUS',
		'IS_INDIGENOUS',
		'CONTACT_NUMBER',
		'TIN_NO',
		'SSS_NO',
		'GSIS_NO',
		'EMAIL_ADDRESS',
		'EDUCATIONAL_ATTAINMENT',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function t_household_information()
	{
		return $this->belongsTo(\App\Models\THouseholdInformation::class, 'HOUSEHOLD_ID');
	}

	public function t_barangay_officials()
	{
		return $this->hasMany(\App\Models\TBarangayOfficial::class, 'RESIDENT_ID');
	}

	public function t_blotters()
	{
		return $this->hasMany(\App\Models\TBlotter::class, 'ACCUSED_RESIDENT');
	}

	public function t_childen_profiles()
	{
		return $this->hasMany(\App\Models\TChildenProfile::class, 'RESIDENT_ID');
	}

	public function t_fathers_profiles()
	{
		return $this->hasMany(\App\Models\TFathersProfile::class, 'RESIDENT_ID');
	}

	public function t_hs_adolescents()
	{
		return $this->hasMany(\App\Models\THsAdolescent::class, 'RESIDENT_ID');
	}

	public function t_hs_chronic_coughs()
	{
		return $this->hasMany(\App\Models\THsChronicCough::class, 'RESIDENT_ID');
	}

	public function t_hs_chronic_diseases()
	{
		return $this->hasMany(\App\Models\THsChronicDisease::class, 'RESIDENT_ID');
	}

	public function t_hs_family_plannings()
	{
		return $this->hasMany(\App\Models\THsFamilyPlanning::class, 'RESIDENT_ID');
	}

	public function t_hs_newborns()
	{
		return $this->hasMany(\App\Models\THsNewborn::class, 'RESIDENT_ID');
	}

	public function t_hs_non_family_planning_users()
	{
		return $this->hasMany(\App\Models\THsNonFamilyPlanningUser::class, 'RESIDENT_ID');
	}

	public function t_hs_pregnants()
	{
		return $this->hasMany(\App\Models\THsPregnant::class, 'RESIDENT_ID');
	}

	public function t_hs_pwds()
	{
		return $this->hasMany(\App\Models\THsPwd::class, 'RESIDENT_ID');
	}

	public function t_issuances()
	{
		return $this->hasMany(\App\Models\TIssuance::class, 'RESIDENT_ID');
	}

	public function t_mothers_profiles()
	{
		return $this->hasMany(\App\Models\TMothersProfile::class, 'RESIDENT_ID');
	}
}
