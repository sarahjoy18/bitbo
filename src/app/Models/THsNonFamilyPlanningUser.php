<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class THsNonFamilyPlanningUser
 * 
 * @property int $NON_FP_ID
 * @property int $RESIDENT_ID
 * @property int $IS_INTERESTED_IN_FP
 * @property string $REASONS_NOT_USING
 * @property \Carbon\Carbon $DATE_OF_VISIT
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \App\Models\TResidentBasicInfo $t_resident_basic_info
 *
 * @package App\Models
 */
class THsNonFamilyPlanningUser extends Eloquent
{
	protected $primaryKey = 'NON_FP_ID';
	public $timestamps = false;

	protected $casts = [
		'RESIDENT_ID' => 'int',
		'IS_INTERESTED_IN_FP' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'DATE_OF_VISIT',
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'RESIDENT_ID',
		'IS_INTERESTED_IN_FP',
		'REASONS_NOT_USING',
		'DATE_OF_VISIT',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function t_resident_basic_info()
	{
		return $this->belongsTo(\App\Models\TResidentBasicInfo::class, 'RESIDENT_ID');
	}
}
