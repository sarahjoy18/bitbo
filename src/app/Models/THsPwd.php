<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class THsPwd
 * 
 * @property int $PWD_ID
 * @property int $RESIDENT_ID
 * @property string $DISABILITY
 * @property \Carbon\Carbon $DATE_OF_DEATH
 * @property string $REASON_OF_DEATH
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \App\Models\TResidentBasicInfo $t_resident_basic_info
 *
 * @package App\Models
 */
class THsPwd extends Eloquent
{
	protected $table = 't_hs_pwd';
	protected $primaryKey = 'PWD_ID';
	public $timestamps = false;

	protected $casts = [
		'RESIDENT_ID' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'DATE_OF_DEATH',
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'RESIDENT_ID',
		'DISABILITY',
		'DATE_OF_DEATH',
		'REASON_OF_DEATH',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function t_resident_basic_info()
	{
		return $this->belongsTo(\App\Models\TResidentBasicInfo::class, 'RESIDENT_ID');
	}
}
