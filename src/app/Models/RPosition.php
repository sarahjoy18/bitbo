<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class RPosition
 * 
 * @property int $POSITION_ID
 * @property string $POSITION_NAME
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \Illuminate\Database\Eloquent\Collection $t_users
 *
 * @package App\Models
 */
class RPosition extends Eloquent
{
	protected $table = 'r_position';
	protected $primaryKey = 'POSITION_ID';
	public $timestamps = false;

	protected $casts = [
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'POSITION_NAME',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function t_users()
	{
		return $this->hasMany(\App\Models\TUser::class, 'POSITION_ID');
	}
}
