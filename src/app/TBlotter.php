<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class TBlotter
 * 
 * @property int $BLOTTER_ID
 * @property int $BLOTTER_SUBJECT
 * @property int $USER_ID
 * @property int $BARANGAY_ID
 * @property string $BLOTTER_CODE
 * @property \Carbon\Carbon $INCIDENT_DATE
 * @property string $INCIDENT_AREA
 * @property string $COMPLAINT_NAME
 * @property int $ACCUSED_RESIDENT
 * @property string $COMPLAINT_STATEMENT
 * @property string $RESOLUTION
 * @property \Carbon\Carbon $COMPLAINT_DATE
 * @property \Carbon\Carbon $CLOSED_DATE
 * @property string $STATUS
 * @property int $ACTIVE_FLAG
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * 
 * @property \App\Models\TResidentBasicInfo $t_resident_basic_info
 * @property \App\Models\RBlotterSubject $r_blotter_subject
 * @property \Illuminate\Database\Eloquent\Collection $t_patawags
 *
 * @package App\Models
 */
class TBlotter extends Eloquent
{
	protected $table = 't_blotter';
	protected $primaryKey = 'BLOTTER_ID';
	public $timestamps = false;

	protected $casts = [
		'BLOTTER_SUBJECT' => 'int',
		'USER_ID' => 'int',
		'BARANGAY_ID' => 'int',
		'ACCUSED_RESIDENT' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'INCIDENT_DATE',
		'COMPLAINT_DATE',
		'CLOSED_DATE',
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'BLOTTER_SUBJECT',
		'USER_ID',
		'BARANGAY_ID',
		'BLOTTER_CODE',
		'INCIDENT_DATE',
		'INCIDENT_AREA',
		'COMPLAINT_NAME',
		'ACCUSED_RESIDENT',
		'COMPLAINT_STATEMENT',
		'RESOLUTION',
		'COMPLAINT_DATE',
		'CLOSED_DATE',
		'STATUS',
		'ACTIVE_FLAG',
		'CREATED_AT',
		'UPDATED_AT'
	];

	public function t_resident_basic_info()
	{
		return $this->belongsTo(\App\Models\TResidentBasicInfo::class, 'ACCUSED_RESIDENT');
	}

	public function r_blotter_subject()
	{
		return $this->belongsTo(\App\Models\RBlotterSubject::class, 'BLOTTER_SUBJECT');
	}

	public function t_patawags()
	{
		return $this->hasMany(\App\Models\TPatawag::class, 'BLOTTER_ID');
	}
}
